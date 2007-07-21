Return-Path: <linux-kernel-owner+w=401wt.eu-S1763375AbXGUTHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763375AbXGUTHv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbXGUTHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:07:43 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:49522 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbXGUTHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:07:42 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 21 Jul 2007 15:05:47 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use menuconfig objects - Fusion
In-Reply-To: <Pine.LNX.4.64.0707182035080.5385@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0707211501570.5853@localhost.localdomain>
References: <200705102317.l4ANHrUC001117@shell0.pdx.osdl.net>
 <Pine.LNX.4.64.0707182035080.5385@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007, Jan Engelhardt wrote:

> -menu "Fusion MPT device support"
> +menuconfig FUSION
> +	bool "Fusion MPT device support"
>  	depends on PCI
> +	---help---
> +	Say Y here to get to see options for Fusion Message
> +	Passing Technology (MPT) drivers.
> +	This option alone does not add any kernel code.
> +
> +	If you say N, all options in this submenu will be skipped and disabled.
>
...
> +if FUSION
>
>  config FUSION_SPI
...
> +endif # FUSION


  i just *know* i'm going to regret asking this, but is there a
compelling reason why the internal contents of a "menuconfig FUBAR"
needs to still be surrounded by a "if FUBAR" condition?  wouldn't it
be philosophically cleaner if the internals of a menuconfig structure
*automatically* depended on selection of the menuconfig and the "if"
part was implicit?

  and having said that, i realize that there are menuconfig examples
for which the above is not strictly true, but i can't remember where
i've seen them.  all i remember about them is that they we're a bit
confusing.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
