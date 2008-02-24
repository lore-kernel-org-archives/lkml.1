Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbYBXSzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbYBXSzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 13:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYBXSzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 13:55:36 -0500
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:25004 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752610AbYBXSzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 13:55:36 -0500
X-YMail-OSG: Mgsiw8kVM1katDpHcBT6qfVyBpH.YF7YnQbNofa_Sst1UWbqV0EwPGfAFUP8CnowPaH7ncI9Xw--
X-RocketYMMF: rancidfat
Date: Sun, 24 Feb 2008 10:55:34 -0800 (PST)
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
Message-ID: <305318.15851.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Adrian Bunk <bunk@kernel.org> wrote:

> This patch makes the needlessly global smk_unlbl_ambient() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>

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
> 
> 
> 


Casey Schaufler
casey@schaufler-ca.com
