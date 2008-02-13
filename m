Return-Path: <linux-kernel-owner+w=401wt.eu-S1764311AbYBMWVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764311AbYBMWVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbYBMWUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:20:52 -0500
Received: from web36601.mail.mud.yahoo.com ([209.191.85.18]:21724 "HELO
	web36601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750767AbYBMWUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:20:51 -0500
X-YMail-OSG: ZHxDXbYVM1mdCZPJ9jXy1FCNiITWgJZk.A2iKFbkBC_ILEUv.K4zGWuuq7VNCiHYsg0m_VA5AHNXxxP7VbwuC7lo4YRzW1QAImowMOW.Cfcgi2rSYOY-
X-RocketYMMF: rancidfat
Date: Wed, 13 Feb 2008 14:20:43 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [2.6 patch] make smackfs.c:smk_cipso_doi() static
To: Adrian Bunk <bunk@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080213213035.GI3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <990098.98014.qm@web36601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Adrian Bunk <bunk@kernel.org> wrote:

> smk_cipso_doi() can become static.

This change is included in a patch I hope to submit today.

> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
> BTW: -ENOMAINTAINERSENTRY
> 
> 299c2883384303ca7730df8fa4baae9194bd5d13 diff --git
> a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 15aa37f..13462ff 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -336,7 +336,7 @@ static const struct file_operations smk_load_ops = {
>  /**
>   * smk_cipso_doi - initialize the CIPSO domain
>   */
> -void smk_cipso_doi(void)
> +static void smk_cipso_doi(void)
>  {
>  	int rc;
>  	struct cipso_v4_doi *doip;
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
