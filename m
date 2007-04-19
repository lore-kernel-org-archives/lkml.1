Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbXDSXv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbXDSXv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbXDSXv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:51:27 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754326AbXDSXv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:51:26 -0400
Date: Thu, 19 Apr 2007 16:51:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       Jes Sorensen <jes@sgi.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] ia64 sn xpc: Convert to use kthread API.
Message-Id: <20070419165103.5b671b28.akpm@linux-foundation.org>
In-Reply-To: <1176969574439-git-send-email-ebiederm@xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<1176969574439-git-send-email-ebiederm@xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 01:58:44 -0600
"Eric W. Biederman" <ebiederm@xmission.com> wrote:

> 
> This patch starts the xpc kernel threads using kthread_run
> not a combination of kernel_thread and daemonize.  Resuling
> in slightly simpler and more maintainable code.
> 
> Cc: Jes Sorensen <jes@sgi.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  arch/ia64/sn/kernel/xpc_main.c |   31 +++++++++++++------------------

Another driver which should be fully converted to the kthread API:
kthread_stop() and kthread_should_stop().

And according to my logs, this driver was added to the tree more than
a year _after_ the kthread interface was made available.

This isn't good.
