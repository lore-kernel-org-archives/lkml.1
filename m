Return-Path: <linux-kernel-owner+w=401wt.eu-S1422768AbXDSXiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422768AbXDSXiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422745AbXDSXiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:38:05 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030649AbXDSXiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:38:03 -0400
Date: Thu, 19 Apr 2007 16:37:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] macintosh/therm_windtunnel.c: Convert to kthread API.
Message-Id: <20070419163740.9035654d.akpm@linux-foundation.org>
In-Reply-To: <11769695873569-git-send-email-ebiederm@xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<11769695873569-git-send-email-ebiederm@xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 01:58:48 -0600
"Eric W. Biederman" <ebiederm@xmission.com> wrote:

> Start the g4fand using kthread_run not a combination
> of kernel_thread and deamonize.  This makes the code
> a little simpler and more maintainable.

I had a bit of trouble reviewing this one because I was laughing so hard at
the attempted coding-style in that driver.  Oh well.

I continue creeping into Christoph's camp - there's quite a bit of
open-coded gunk which would go away if we were to teach this driver about
kthread_should_stop() and kthread_stop(), and the conversion looks awfully
easy to do.  It's a shame to stop here.

Oh well, I guess at least this is some forward progress.
