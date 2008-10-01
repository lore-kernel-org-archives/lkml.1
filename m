Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYJAIBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYJAIBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYJAIBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:01:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38467 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbYJAIBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:01:01 -0400
Date: Wed, 1 Oct 2008 10:00:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [PATCH -tip] sdhci: 'scratch' may be used uninitialized
Message-ID: <20081001080048.GB25832@elte.hu>
References: <1222847847-7127-1-git-send-email-steven@uplinklabs.net> <1222847847-7127-2-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222847847-7127-2-git-send-email-steven@uplinklabs.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed Pierre Ossman)

* Steven Noonan <steven@uplinklabs.net> wrote:

> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> ---
>  drivers/mmc/host/sdhci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index e3a8133..6257677 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -177,7 +177,7 @@ static void sdhci_read_block_pio(struct sdhci_host *host)
>  {
>  	unsigned long flags;
>  	size_t blksize, len, chunk;
> -	u32 scratch;
> +	u32 uninitialized_var(scratch);
>  	u8 *buf;
>  
>  	DBG("PIO reading\n");
> -- 
> 1.6.0.2
