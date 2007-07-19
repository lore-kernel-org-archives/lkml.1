Return-Path: <linux-kernel-owner+w=401wt.eu-S937711AbXGSI6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937711AbXGSI6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 04:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934789AbXGSI6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 04:58:31 -0400
Received: from za-gw.sanpeople.com ([196.211.225.226]:1614 "EHLO
	za-gw.sanpeople.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934690AbXGSI63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 04:58:29 -0400
X-Greylist: delayed 778 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2007 04:58:28 EDT
Subject: Re: [PATCH 1/1][RESEND] Driver for the Atmel on-chip SSC on AT32AP
	and AT91.
From: Andrew Victor <andrew@sanpeople.com>
To: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kernel-avr32 <kernel@avr32linux.org>,
       David Brownell <david-b@pacbell.net>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Hans-Christian Egtvedt <egtvedt@samfundet.no>
In-Reply-To: <469E6C00.3060506@atmel.com>
References: <469E6C00.3060506@atmel.com>
Content-Type: text/plain
Organization: Multenet Technologies (Pty) Ltd
Message-Id: <1184833759.15007.33.camel@fuzzie.sanpeople.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.2.2 
Date: 19 Jul 2007 10:29:19 +0200
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi Hans-Christian,

> This driver is used in the ALSA sound driver for the AT73C213 external DAC on
> the ATSTK1000 development board for AVR32. This sound driver will be submitted
> soon.

Seems to be more of an SCC unit allocation library, but OK.

I've also forwarded a copy of the patch to Frank Mandarino
<fmandarino@endrelia.com> for his comments.  He maintains the current
AT91 SSC & ALSA support.  <sound/soc/at91/>


> +/* SSC Receive Clock Mode Register */
> +#define SSC_RCMR			0x00000010
> +#define SSC_RCMR_CKG_SIZE			 2
> +#define SSC_RCMR_CKG_OFFSET			 6
> +#define SSC_RCMR_CKI_SIZE			 1
> +#define SSC_RCMR_CKI_OFFSET			 5
> +#define SSC_RCMR_CKO_SIZE			 3

I'm personally not a fan of the register & bit definition format the
AVR32 driver seem to use.
Can we not rather move the existing include/asm-arm/arch-at91/at91_ssc.h
to somewhere shared as atmel_ssc.h ?


Regards,
  Andrew Victor


