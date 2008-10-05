Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbYJEWoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbYJEWoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 18:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbYJEWoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 18:44:22 -0400
Received: from nudl.linbit.com ([212.69.162.21]:59098 "EHLO mail.linbit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754954AbYJEWoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 18:44:22 -0400
X-Greylist: delayed 1820 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Oct 2008 18:44:21 EDT
Date: Mon, 6 Oct 2008 00:13:57 +0200
From: Martin Gerhard Loschwitz <martin.loschwitz@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: kkeil@suse.de
Subject: Linux 2.6.27-rc8 and hfcplus / mISDN detection problem
Message-ID: <20081005221357.GA15296@madkiss.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

i'm happy to see that mISDN made it into the mainline kernel -- i just tried
to use 2.6.27-rc8 with mISDN yesterday, and noticed that the hfcplus-module
does no longer detect my beroNet HFC-4S ISDN card. The "old" mISDN just works
flawlessly with that card.

This is the lspci-output:

02:00.0 ISDN controller: Cologne Chip Designs GmbH ISDN network Controller [HFC-4S] (rev 01)
	Subsystem: Cologne Chip Designs GmbH Device b762
	Flags: medium devsel, IRQ 169
	I/O ports at 2000 [size=8]
	Memory at de100000 (32-bit, non-prefetchable) [disabled] [size=4K]
	Capabilities: [40] Power Management version 2
	Kernel driver in use: hfc_multi
	Kernel modules: hfcmulti, ipmi_si

With 2.6.18 and mISDN 1.1.8, the card gets detected without any problems:

HFC-multi: card manufacturer: 'Cologne Chip AG' card name: 'HFC-4S Beronet Card PCIe' clock: double
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 169
HFC-4S#1: defined at IOBASE 0x2000 IRQ 169 HZ 250 leds-type 2
HFC_multi: resetting HFC with chip ID=0xc revision=1
hfcpci_probe: DIPs(0x8f) jumpers(0x0)
1 devices registered

However, in 2.6.27-rc8, the kernel only tells me that I should "contact
my vendor for a driver". I guess that maybe somewhen during the various
cleanups, there was one PCI-ID too much removed, but I did not find out
how to put it back in. 

Can somebody help me out with a patch, maybe, to re-active the support for
this card?

Please CC me in replies as I am not subscribed to the list.

Thanks in advance

Martin G. Loschwitz

: Martin Loschwitz                        Tel +43-1-8178292-63 :                                                                                                                                                                                                     
: LINBIT Information Technologies GmbH    Fax +43-1-8178292-82 :                                                                                                                                                                                                                    
: Vivenotgasse 48, A-1120 Vienna/Europe  http://www.linbit.com :
