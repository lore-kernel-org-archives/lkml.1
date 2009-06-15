Return-Path: <linux-kernel-owner+w=401wt.eu-S935743AbZFOVf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935743AbZFOVf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933516AbZFOVfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:35:48 -0400
Received: from monster.nessie.de ([84.200.20.120]:42806 "EHLO
	monster.nessie.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934528AbZFOVfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:35:47 -0400
From: Michael Roth <mroth@nessie.de>
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 5/6] Unified AVR32/AT91 MCI Driver Support for a VCC Pin
Date: Mon, 15 Jun 2009 23:35:34 +0200
User-Agent: KMail/1.9.10
Cc: Rob Emanuele <poorarm@shoreis.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Andrew Victor <avictor.za@gmail.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx
References: <c8284b5b0906121802h3545fbfflf498fbba30fe42be@mail.gmail.com>
In-Reply-To: <c8284b5b0906121802h3545fbfflf498fbba30fe42be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906152335.48926.mroth@nessie.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index 1c1a4b3..a639b93 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -214,6 +214,8 @@ struct atmel_mci_slot {
>
>  	int			detect_pin;
>  	int			wp_pin;
> +	int			vcc_pin;
> +	bool			vcc_pin_act_low;

Maybe, just 'vcc_active_low' is more clear?

Most other kernel code use 'active_low' or 'xyz_active_low' as far as I can 
see.

