Return-Path: <linux-kernel-owner+w=401wt.eu-S1759193AbZD2SSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193AbZD2SSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759085AbZD2SSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:18:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39640 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760698AbZD2SSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:18:40 -0400
Date: Wed, 29 Apr 2009 20:18:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: akpm@linux-foundation.org, greg@kroah.com, tglx@linutronix.de,
       hpa@zytor.com, dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/21] amd64_edac: add debugging/testing code
Message-ID: <20090429181820.GB8321@elte.hu>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <1241024107-14535-20-git-send-email-borislav.petkov@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241024107-14535-20-git-send-email-borislav.petkov@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <borislav.petkov@amd.com> wrote:

> From: Doug Thompson <dougthompson@xmission.com>
> 
> This is for dumping different registers and testing the address mapping
> logic using the ECC syndromes.
> 
> Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  drivers/edac/amd64_edac.c |  214 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 214 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 43f236d..b1a7e8c 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -4407,3 +4407,217 @@ static int amd64_check_ecc_enabled(struct amd64_pvt *pvt)
>  	return rc;
>  }
>  
> +#ifdef	CONFIG_EDAC_DEBUG

should be in a separate .c file too i suspect.

	Ingo
