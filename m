Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbZLTVG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbZLTVG3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 16:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbZLTVG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 16:06:26 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:48285 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754654AbZLTVG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 16:06:26 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Andy Walls <awalls@radix.net>
Subject: Re: [PATCH 2/3] g_NCR5380: fix broken MMIO compilation
Date: Sun, 20 Dec 2009 22:06:13 +0100
User-Agent: KMail/1.9.10
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200912202041.29363.linux@rainbow-software.org> <1261340144.3057.21.camel@palomino.walls.org>
In-Reply-To: <1261340144.3057.21.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912202206.14995.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 December 2009 21:15:44 Andy Walls wrote:
> On Sun, 2009-12-20 at 20:41 +0100, Ondrej Zary wrote:
> > The ifdefs are broken so the MMIO code is never compiled and so it's
> > broken too. Fix them all.
> > Untested as I don't have the hardware.
>
> I still have a DTC-xxxx card in use (under Windows95) and a SUMO SCSI AT
> (usable with g_NCR5380 with a minor hack to toggle a flip flop that
> gates interrupts to the ISA bus).  :)
>
> I think both cards are wired to use I/O space and not memory space, so
> they are of no help for testing MMIO. :(

I have some cards but probably none of them is memory mapped:
DTCT-436P (PnP) - this seems to work (but don't have proper SCSI cable to test 
it really)
HP C2505 (53C400A) - does not work (wrote about this card to LKML in 2004)
Canon FG2-5202 (53C400) - does not work

> But, ah memories....
>
> Regards,
> Andy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Ondrej Zary
