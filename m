Return-Path: <linux-kernel-owner+w=401wt.eu-S1763026AbZFOQff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763026AbZFOQff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760948AbZFOQf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:35:27 -0400
Received: from mail.atmel.fr ([81.80.104.162]:64815 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759347AbZFOQf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:35:27 -0400
Message-ID: <4A36784A.1000109@atmel.com>
Date: Mon, 15 Jun 2009 18:35:22 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Rob Emanuele <poorarm@shoreis.com>
CC: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Andrew Victor <avictor.za@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx
Subject: Re: [PATCH 2/6] Unified AVR32/AT91 MCI Platform Driver
References: <c8284b5b0906121759o4057deb6kf59f818fa759ce57@mail.gmail.com>
In-Reply-To: <c8284b5b0906121759o4057deb6kf59f818fa759ce57@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

Rob Emanuele :
> +
> +        for (i = 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
> +                if (data->slot[i].bus_width) {
> +                        /* input/irq */
> +                        if (data->slot[i].detect_pin) {
> +
> at91_set_gpio_input(data->slot[i].detect_pin, 1);
> +                                at91_set_deglitch(data->slot[i].detect_pin, 1);
> +			}
> +			if (data->slot[i].wp_pin)

There is some indentation errors in this patch (blank instead of tabs).

Best regards,
-- 
Nicolas Ferre

