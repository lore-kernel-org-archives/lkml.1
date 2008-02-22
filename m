Return-Path: <linux-kernel-owner+w=401wt.eu-S934501AbYBVUIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934501AbYBVUIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765992AbYBVUFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:05:13 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:38218 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890AbYBVUFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:05:10 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] make smackfs.c:smk_unlbl_ambient() static
Date: Fri, 22 Feb 2008 15:05:04 -0500
User-Agent: KMail/1.9.7
Cc: Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org
References: <20080222195807.GB1409@cs181133002.pp.htv.fi>
In-Reply-To: <20080222195807.GB1409@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802221505.04913.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2008 2:58:07 pm Adrian Bunk wrote:
> This patch makes the needlessly global smk_unlbl_ambient() static.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Fine with me.

Acked-by: Paul Moore <paul.moore@hp.com>

> ---
> 60c7072cb922cdecdb8a4f08e5710c014e0e8a8c diff --git
> a/security/smack/smackfs.c b/security/smack/smackfs.c index
> 358c92c..7c6e671 100644
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



-- 
paul moore
linux security @ hp
