Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbXJIR45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbXJIR45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 13:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbXJIR4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 13:56:48 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:33346 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbXJIR4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 13:56:47 -0400
Message-ID: <470BC0D5.70305@freescale.com>
Date: Tue, 09 Oct 2007 12:56:37 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Anton Altaparmakov <aia21@cam.ac.uk>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
References: <4706822D.4070509@freescale.com> <Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr> <470691EB.7020209@freescale.com> <AECA61F9-0EF6-4883-9D37-004C00C57417@cam.ac.uk> <4706A842.9030507@freescale.com> <20071009174623.GC4003@csclub.uwaterloo.ca>
In-Reply-To: <20071009174623.GC4003@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:

>> You're talking about byte endian.  I'm talking about bit endian -- the 
>> order of bits within a byte.  Software cannot know what the bit endian is, 
>> but external devices that have memory-mapped registers can know.
> 
> The guy wiring up the hardware should connect the wires correctly.

I'm sure they're correct, my problem is that how can my driver know what they are?

> Doesn't the bus usually have some definition of bit order which the
> device would have to adhere to?  After all there must be address lines
> somewhere.

I was hoping that there would be some compile-time constant I could check that 
would give me this information.

> Does this perhaps offer anything useful?
> http://www.linuxjournal.com/article/6788

Yeah, I read that article some time ago when trying to diagnose the problem I 
was seeing.  It does explain the point I'm trying to make.  We have a device 
that's used on two product lines: one ARM-based, and one PowerPC.  The ARM is 
little-endian, and the PowerPC is big-endian.  The device can support 
little-endian or big-endian data, as long as the bit-order matches the byte-order.

For now, I'm going to have to assume that they do match.

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
