Return-Path: <linux-kernel-owner+w=401wt.eu-S934454AbYBWBJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934454AbYBWBJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 20:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbYBWBJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 20:09:38 -0500
Received: from web36615.mail.mud.yahoo.com ([209.191.85.32]:32971 "HELO
	web36615.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751993AbYBWBJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 20:09:37 -0500
X-YMail-OSG: OphD9zgVM1lcgOklAZjzCtzax5RJoeHtIFfhhm7LMvKY2GNtOMeUjwURtxzgFZ.AsLIzVSidQhRnYNqcjeqrerGJLeFXSVEbZOpFm5vHQB.3ir9.z9o-
X-RocketYMMF: rancidfat
Date: Fri, 22 Feb 2008 17:09:36 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [2.6 patch] make smackfs.c:smk_unlbl_ambient() static
To: Adrian Bunk <bunk@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>,
       Paul Moore <paul.moore@hp.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080222195807.GB1409@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <244048.80864.qm@web36615.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Adrian Bunk <bunk@kernel.org> wrote:

> This patch makes the needlessly global smk_unlbl_ambient() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

Oops.

> 
> ---
> 60c7072cb922cdecdb8a4f08e5710c014e0e8a8c diff --git
> a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 358c92c..7c6e671 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -371,7 +371,7 @@ void smk_cipso_doi(void)
>  /**
>   * smk_unlbl_ambient - initialize the unlabeled domain
>   */
> -void smk_unlbl_ambient(char *oldambient)
> +static void smk_unlbl_ambient(char *oldambient)
>  {
>  	int rc;
>  	struct netlbl_audit audit_info;
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
