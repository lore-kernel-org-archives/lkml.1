Return-Path: <linux-kernel-owner+w=401wt.eu-S1750930AbXDSQ05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930AbXDSQ05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbXDSQ05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:26:57 -0400
Received: from pat.uio.no ([129.240.10.15]:57149 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbXDSQ04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:26:56 -0400
Subject: Re: [PATCH] nfs4state reclaimer: Remove unnecessary allow_signal
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
In-Reply-To: <1176969636656-git-send-email-ebiederm@xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	 <1176969636656-git-send-email-ebiederm@xmission.com>
Content-Type: text/plain
Date: Thu, 19 Apr 2007 12:26:42 -0400
Message-Id: <1177000002.6663.16.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.2, required=12.0, autolearn=disabled, AWL=-0.161)
X-UiO-Scanned: DD606DE1EC4F51597528EDF030809722537D7E27
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -1 maxlevel 200 minaction 2 bait 0 mail/h: 533 total 1195355 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-19 at 01:59 -0600, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Cc: Neil Brown <neilb@suse.de>
> Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  fs/nfs/nfs4state.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
> index 5fffbdf..d16393f 100644
> --- a/fs/nfs/nfs4state.c
> +++ b/fs/nfs/nfs4state.c
> @@ -775,8 +775,6 @@ static int reclaimer(void *ptr)
>  	struct rpc_cred *cred;
>  	int status = 0;
>  
> -	allow_signal(SIGKILL);
> -
>  	/* Ensure exclusive access to NFSv4 state */
>  	lock_kernel();
>  	down_write(&clp->cl_sem);

Ditto...



