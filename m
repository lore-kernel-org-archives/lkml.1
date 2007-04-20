Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbXDTAbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbXDTAbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 20:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXDTAbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 20:31:17 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658AbXDTAbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 20:31:16 -0400
Date: Thu, 19 Apr 2007 17:30:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] sparc64/power.c: Convert to use the kthread API
Message-Id: <20070419173021.9680e2a7.akpm@linux-foundation.org>
In-Reply-To: <1176969564948-git-send-email-ebiederm@xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<1176969564948-git-send-email-ebiederm@xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 01:58:39 -0600
"Eric W. Biederman" <ebiederm@xmission.com> wrote:

> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> This starts the sparc64 powerd using kthread_run
> instead of kernel_thread and daemonize.  Making the
> code slightly simpler and more maintainable.
> 
> In addition the unnecessary flush_signals is removed.

Looks OK.  This code could perhaps be switched to call_usermodehelper().

> +		task = kthread_urn(powerd, NULL, "powerd");

I'll fix that up before Dave notices ;)
