Return-Path: <linux-kernel-owner+w=401wt.eu-S932830AbXBTEfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbXBTEfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 23:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932834AbXBTEfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 23:35:33 -0500
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3069 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830AbXBTEfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 23:35:32 -0500
Message-ID: <45DA7A8F.3030008@xs4all.nl>
Date: Tue, 20 Feb 2007 05:35:27 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Krzysztof Halasa <khc@pm.waw.pl>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl>	<20070218155445.GV7584@csclub.uwaterloo.ca>	<45D87BA2.9020001@xs4all.nl>	<20070218193901.GN7582@csclub.uwaterloo.ca>	<45D9BDBF.8040405@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain>
In-Reply-To: <m3odnpq3yr.fsf@maximus.localdomain>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Udo van den Heuvel <udovdh@xs4all.nl> writes:
> 
>> At the bottom I added a dmesg output of the kernel after boot.
>> I more or less know that irq 20 for the DVB-S card (saa7146 (1)) is
>> 'working'. I know that irq 16 for saa7146 (0) (DVB-T) is not working for
>> i2c although the card does work perfectly for DVB-T reception (picture,
>> low CPU load, etc) with only reception as the bottleneck.
> 
> BTW: Can you check which device # and IRQ does the card get if plugged
> directly into the PCI slot on board (without the riser)?

BTW: 2.6.18-1.2798.fc6 (Fedora kernel) gave me in dmesg:

Linux video capture interface: v2.00
saa7146: register extension 'budget_av'.
saa7146: found saa7146 @ mem f896a000 (revision 1, irq 145) (0x153b,0x1157).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (Terratec Cinergy 1200 DVB-T).
adapter failed MAC signature check
encoded MAC from EEPROM was
ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
input: PC Speaker as /class/input/input2
KNC1-0: MAC addr = 00:0a:ac:01:d6:87
DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
budget-av: ci interface initialised.
saa7146: found saa7146 @ mem f89e6000 (revision 1, irq 153) (0x153b,0x1155).
saa7146 (1): dma buffer size 192512
DVB: registering new adapter (TerraTec Cinergy 1200 DVB-S).
adapter failed MAC signature check
encoded MAC from EEPROM was
ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
KNC1-1: MAC addr = 00:0a:ac:12:93:8d
DVB: registering frontend 1 (ST STV0299 DVB-S)...
budget-av: ci interface initialised.

(irq 145 and 153!?)

I think I can do some testing this afternoon.

Kind regards,
Udo


