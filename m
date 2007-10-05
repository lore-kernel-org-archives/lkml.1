Return-Path: <linux-kernel-owner+w=401wt.eu-S1763613AbXJETnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763613AbXJETnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759106AbXJETnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:43:15 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46340 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705AbXJETnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:43:15 -0400
Date: Fri, 5 Oct 2007 21:43:14 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Timur Tabi <timur@freescale.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
In-Reply-To: <470691EB.7020209@freescale.com>
Message-ID: <Pine.LNX.4.64.0710052138070.13406@fbirervta.pbzchgretzou.qr>
References: <4706822D.4070509@freescale.com>
 <Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr>
 <470691EB.7020209@freescale.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 5 2007 14:35, Timur Tabi wrote:
>> 
>> standard x86:
>> ---LSB-- ---2SB-- ---3SB-- ---MSB-- [bytes] LITTLE_ENDIAN
>> M765432L M765432L M765432L M765432L  [bits] ?_BITFIELD
>> 
>> (Not sure what bitfield type, but I'd guess BIG_ENDIAN_BITFIELD)
>
> Are you sure?  I would think that all machines would have the same byte and bit
> endian, otherwise you'd never be able to put a 16-bit value into a shift
> register.  Your bits will be shifted out like this:

Bit representation is left to the CPU, so 1 << 1 will always be 2,
regardless of whether the byte, when sent out to the network,
is 01000000 or 00000010. Endianess becomes important as soon
as the packet is on the network, of course.
