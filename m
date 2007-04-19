Return-Path: <linux-kernel-owner+w=401wt.eu-S1766851AbXDSQWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766851AbXDSQWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766852AbXDSQWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:22:49 -0400
Received: from pat.uio.no ([129.240.10.15]:54761 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766851AbXDSQWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:22:48 -0400
Subject: Re: [PATCH] nfsv4 delegation: Convert to kthread API
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
In-Reply-To: <1176969635120-git-send-email-ebiederm@xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	 <1176969635120-git-send-email-ebiederm@xmission.com>
Content-Type: text/plain
Date: Thu, 19 Apr 2007 12:22:24 -0400
Message-Id: <1176999744.6663.14.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.056)
X-UiO-Scanned: D48F0AF16D0D8A388328BAE9FD28868999097452
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 461 total 1195283 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-19 at 01:59 -0600, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> To start the nfsv4-delegreturn thread this patch uses
> kthread_run instead of a combination of kernel_thread
> and daemonize.
> 
> In addition allow_signal(SIGKILL) is removed from
> the expire delegations thread.

Again vetoed, for the same reason.

Trond

