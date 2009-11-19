Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbZKSVsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbZKSVsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 16:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757154AbZKSVsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 16:48:51 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:15267 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbZKSVsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 16:48:51 -0500
X-SpamScore: -29
X-BigFish: VPS-29(zz1432R98dN936eM9371Pzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B05BD40.1080701@am.sony.com>
Date: Thu, 19 Nov 2009 13:48:48 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Scott Wood <scottwood@freescale.com>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] powerpc: Fixup last users of irq_chip->typename - V2
References: <20091117224852.846805939@linutronix.de>	<20091117224916.566205413@linutronix.de>	<20091118175523.GA12857@b07421-ec1.am.freescale.net>	<alpine.LFD.2.00.0911182141060.24119@localhost.localdomain> <alpine.LFD.2.00.0911191035030.24119@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0911191035030.24119@localhost.localdomain>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Nov 2009 21:48:51.0958 (UTC) FILETIME=[155C9160:01CA6962]
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2009 01:44 AM, Thomas Gleixner wrote:
> The typename member of struct irq_chip was kept for migration purposes
> and is obsolete since more than 2 years. Fix up the leftovers.

> Index: linux-2.6-tip/arch/powerpc/platforms/ps3/interrupt.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/powerpc/platforms/ps3/interrupt.c
> +++ linux-2.6-tip/arch/powerpc/platforms/ps3/interrupt.c
> @@ -152,7 +152,7 @@ static void ps3_chip_eoi(unsigned int vi
>   */
> 
>  static struct irq_chip ps3_irq_chip = {
> -       .typename = "ps3",
> +       .name = "ps3",
>         .mask = ps3_chip_mask,
>         .unmask = ps3_chip_unmask,
>         .eoi = ps3_chip_eoi,


This PS3 part looks OK.

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>

