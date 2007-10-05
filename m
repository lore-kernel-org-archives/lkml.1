Return-Path: <linux-kernel-owner+w=401wt.eu-S1763708AbXJETf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763708AbXJETf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759460AbXJETfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:35:15 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:54493 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759353AbXJETfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:35:13 -0400
Message-ID: <470691EB.7020209@freescale.com>
Date: Fri, 05 Oct 2007 14:35:07 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
References: <4706822D.4070509@freescale.com> <Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Oct 5 2007 13:27, Timur Tabi wrote:
>> What's the difference between __LITTLE_ENDIAN and __LITTLE_ENDIAN_BITFIELD? Can
>> someone give me an example when __BIG_ENDIAN and __LITTLE_ENDIAN_BITFIELD would
>> both be defined simultaneously?
> 
> standard x86:
> ---LSB-- ---2SB-- ---3SB-- ---MSB-- [bytes] LITTLE_ENDIAN
> M765432L M765432L M765432L M765432L  [bits] ?_BITFIELD
> 
> (Not sure what bitfield type, but I'd guess BIG_ENDIAN_BITFIELD)

Are you sure?  I would think that all machines would have the same byte and 
bit endian, otherwise you'd never be able to put a 16-bit value into a shift 
register.  Your bits will be shifted out like this:

<-- 07 06 05 04 03 02 01 00 15 14 13 12 11 10 09 08

So I think x86 is:

---LSB-- ---2SB-- ---3SB-- ---MSB-- [bytes] LITTLE_ENDIAN
L234567M L234567M L234567M L234567M  [bits] LITTLE_ENDIAN_BITFIELD

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
