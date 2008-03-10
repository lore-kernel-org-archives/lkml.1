Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbYCJVSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbYCJVSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYCJVR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:17:56 -0400
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:34589 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751355AbYCJVRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:17:55 -0400
X-YMail-OSG: bLrO7v0VM1nXlhvMw7cUAcJyZmsi8jA99xS2t2pX5fcD94Ep8jHQBF0MbopYiItthr_6D.cgm1fDn_ZJJaaZuijrauEmUPBcfX8YzEeZIfv_JOKRJSc-
X-RocketYMMF: rancidfat
Date: Mon, 10 Mar 2008 14:17:54 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: smack: use cap_task_prctl
To: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Andrew Morgan <morgan@kernel.org>
In-Reply-To: <20080310205456.GA13013@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <785828.4605.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Serge E. Hallyn" <serue@us.ibm.com> wrote:

> With the introduction of per-process securebits, the capabilities-related
> prctl callbacks were moved into cap_task_prctl().  Have smack use
> cap_task_prctl() so that PR_SET_KEEPCAPS is defined.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

> ---
>  security/smack/smack_lsm.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 40066b6..e8ce6b6 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -2493,6 +2493,7 @@ static struct security_operations smack_ops = {
>  	.task_wait = 			smack_task_wait,
>  	.task_reparent_to_init =	cap_task_reparent_to_init,
>  	.task_to_inode = 		smack_task_to_inode,
> +	.task_prctl =			cap_task_prctl,
>  
>  	.ipc_permission = 		smack_ipc_permission,
>  
> -- 
> 1.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 


Casey Schaufler
casey@schaufler-ca.com
