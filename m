Return-Path: <linux-kernel-owner+w=401wt.eu-S935705AbXHNVzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935705AbXHNVzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765746AbXHNVfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:35:07 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58641 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932723AbXHNVfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:35:04 -0400
Date: Tue, 14 Aug 2007 16:35:02 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, James Morris <jmorris@namei.org>,
       chrisw@sous-sol.org, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport cap_inode_killpriv
Message-ID: <20070814213502.GA14497@sergelap.austin.ibm.com>
References: <20070809224254.11f42716.akpm@linux-foundation.org> <20070814212613.GY18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814212613.GY18945@stusta.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Adrian Bunk (bunk@kernel.org):
> On Thu, Aug 09, 2007 at 10:42:54PM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.23-rc1-mm2:
> >...
> > +file-capabilities-clear-fcaps-on-inode-change.patch
> > 
> >  file caps update
> >...
> 
> This patch removes the unused EXPORT_SYMBOL(cap_inode_killpriv).
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
> 68ca3bcc4918d0b84a97318f60fb74c4600d9f6b 
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 7816cdc..9ec5890 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -543,7 +543,6 @@ EXPORT_SYMBOL(cap_bprm_apply_creds);
>  EXPORT_SYMBOL(cap_bprm_secureexec);
>  EXPORT_SYMBOL(cap_inode_setxattr);
>  EXPORT_SYMBOL(cap_inode_removexattr);
> -EXPORT_SYMBOL(cap_inode_killpriv);
>  EXPORT_SYMBOL(cap_task_post_setuid);
>  EXPORT_SYMBOL(cap_task_kill);
>  EXPORT_SYMBOL(cap_task_setscheduler);

Ah yes, bc LSMs can't be modules any more.  But then, why still export
cap_task_setscheduler, for instance?

-serge
