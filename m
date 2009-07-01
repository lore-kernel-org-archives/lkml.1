Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZGAKEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZGAKEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 06:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZGAKER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 06:04:17 -0400
Received: from relay.felk.cvut.cz ([147.32.80.7]:55703 "EHLO
	relay.felk.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbZGAKEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 06:04:16 -0400
X-Greylist: delayed 1986 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jul 2009 06:04:16 EDT
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 26/62] drivers/mmc/host/imxmmc.c: Remove unnecessary semicolons
Date: Wed, 1 Jul 2009 11:26:01 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Pierre Ossman <pierre@ossman.eu>
References: <cover.1246173664.git.joe@perches.com> <d76aa5b943c6cd92a1a02565c681575ecac48678.1246173681.git.joe@perches.com>
In-Reply-To: <d76aa5b943c6cd92a1a02565c681575ecac48678.1246173681.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907011126.02214.pisa@cmp.felk.cvut.cz>
X-FELK-MailScanner-Information: 
X-MailScanner-ID: n619Q4tl076076
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.599, required 5, autolearn=not spam, BAYES_00 -2.60)
X-FELK-MailScanner-From: pisa@cmp.felk.cvut.cz
X-FELK-MailScanner-To: akpm@linux-foundation.org, joe@perches.com,
	linux-kernel@vger.kernel.org, pierre@ossman.eu, trivial@kernel.org
X-FELK-MailScanner-Watermark: 1247045165.52622@nIs3c2VH4iMvc1DIbI3JaA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 June 2009 18:26:31 Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/mmc/host/imxmmc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mmc/host/imxmmc.c b/drivers/mmc/host/imxmmc.c
> index e0be21a..bf98d7c 100644
> --- a/drivers/mmc/host/imxmmc.c
> +++ b/drivers/mmc/host/imxmmc.c
> @@ -652,7 +652,7 @@ static irqreturn_t imxmci_irq(int irq, void *devid)
>  	set_bit(IMXMCI_PEND_STARTED_b, &host->pending_events);
>  	tasklet_schedule(&host->tasklet);
>
> -	return IRQ_RETVAL(handled);;
> +	return IRQ_RETVAL(handled);
>  }
>
>  static void imxmci_tasklet_fnc(unsigned long data)


Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>

==================================================
 PiKRON s.r.o.       Phone/Fax: +420 2 84684676
 Kankovskeho 1235    Phone:     +420 2 84684676
 182 00 Praha 8      WWW:   http://www.pikron.com/
 Czech Republic      e-mail:  pikron@pikron.com
==================================================
-- 
Yours sincerely

                Pavel Pisa
    e-mail:     pisa@cmp.felk.cvut.cz
    www:        http://cmp.felk.cvut.cz/~pisa
    university: http://dce.felk.cvut.cz/
    company:    http://www.pikron.com/
