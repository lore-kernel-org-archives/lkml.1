Return-Path: <linux-kernel-owner+w=401wt.eu-S936934AbXHLPPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936934AbXHLPPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936446AbXHLPK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:10:26 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:41865 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936434AbXHLPKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:10:22 -0400
Subject: Re: [ANNOUNCE] SDIO soon in mainline
From: Marcel Holtmann <marcel@holtmann.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>, Nicolas Pitre <nico@cam.org>
In-Reply-To: <20070722185244.587d5bdc@poseidon.drzeus.cx>
References: <20070722185244.587d5bdc@poseidon.drzeus.cx>
Content-Type: text/plain
Date: Sun, 12 Aug 2007 17:12:31 +0200
Message-Id: <1186931551.6698.88.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I am happy to announce that SDIO support will soon be a standard
> feature in Linux. No more proprietary stacks with all the troubles
> (legal and technical) that go with them.
> 
> The new code is written from scratch by yours truly and Nicolas Pitre.
> There were several stacks out there that were recently made available
> under the GPL, but none of them were in any shape to be merged into the
> kernel.
> 
> Current status is that basic functionality is in place. There is a
> driver model (with device matching and module auto-loading) and
> functions for easy register access. It is also possible to receive
> interrupts from the card.
> 
> There is only one driver in the tree right now (for the standard GPS
> interface), but it should be complete enough for everyone to see how
> the API works.

and as of a few days ago we have a second driver that can handle
Bluetooth Type-A and Type-B SDIO cards. It has been tested with a card
from Socket which is actually manufactured by Toshiba.

hci0:   Type: SDIO
        BD Address: 00:02:C7:xx:xx:xx ACL MTU: 676:4 SCO MTU: 120:3
        HCI Ver: 1.1 (0x1) HCI Rev: 0x0 LMP Ver: 1.1 (0x1) LMP Subver: 0x14b
        Manufacturer: Toshiba Corp. (4)
        Features: 0xff 0xf9 0x21 0x00 0x00 0x00 0x00 0x00
                <3-slot packets> <5-slot packets> <encryption> <slot offset> 
                <timing accuracy> <role switch> <hold mode> <sniff mode> 
                <park state> <SCO link> <HV2 packets> <HV3 packets> 
                <u-law log> <A-law log> <CVSD> 

The code for the btsdio.ko driver can be found here:

http://git.infradead.org/?p=users/holtmann/btsdio.git;a=summary

There are other Bluetooth SDIO cards that don't follow the Type-A or
Type-B standard. These use the UART standard, but unfortunately the
specification for the SDIO UART cards is not public.

Regards

Marcel


