Return-Path: <linux-kernel-owner+w=401wt.eu-S1757854AbZGFJAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbZGFJAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 05:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbZGFJAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 05:00:07 -0400
Received: from d1.icnet.pl ([212.160.220.21]:47831 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318AbZGFJAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 05:00:06 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: "Pandita, Vikram" <vikram.pandita@ti.com>
Subject: Re: [PATCH v2] OMAP1: AMS_DELTA: add modem support
Date: Mon, 6 Jul 2009 10:59:22 +0200
User-Agent: KMail/1.9.10
Cc: Jonathan McDowell <noodles@earth.li>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Tony Lindgren <tony@atomide.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200907051601.49194.jkrzyszt@tis.icnet.pl> <FCCFB4CDC6E5564B9182F639FC35608702F5568724@dbde02.ent.ti.com>
In-Reply-To: <FCCFB4CDC6E5564B9182F639FC35608702F5568724@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907061059.24378.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Monday 06 July 2009 06:49:34 Pandita, Vikram napisał(a):
> Janusz/Alan
>
> >-----Original Message-----
> >From: linux-omap-owner@vger.kernel.org
> > [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of Janusz Krzysztofik
>
> +static int __init ams_delta_modem_init(void)
>
> >+{
> >+	omap_cfg_reg(M14_1510_GPIO2);
> >+	ams_delta_modem_ports[0].irq = gpio_to_irq(2);
> >+	set_irq_type(gpio_to_irq(2), IRQ_TYPE_EDGE_RISING);
>
> There is a recent change on specifying irqflags as example:
> http://patchwork.kernel.org/patch/31888/
>
> There is a dependency for Alan Cox to push this patch first though:
> http://patchwork.kernel.org/patch/31884/
>
> Reference:
> http://lkml.indiana.edu/hypermail/linux/kernel/0906.2/02827.html

I can change and resubmit as v3, then Tony will choose which one applies, OK?

Janusz
