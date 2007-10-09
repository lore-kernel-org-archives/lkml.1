Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbXJIRqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbXJIRqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 13:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbXJIRqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 13:46:25 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:38683 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751459AbXJIRqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 13:46:24 -0400
Date: Tue, 9 Oct 2007 13:46:23 -0400
To: Timur Tabi <timur@freescale.com>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
Message-ID: <20071009174623.GC4003@csclub.uwaterloo.ca>
References: <4706822D.4070509@freescale.com> <Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr> <470691EB.7020209@freescale.com> <AECA61F9-0EF6-4883-9D37-004C00C57417@cam.ac.uk> <4706A842.9030507@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4706A842.9030507@freescale.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 04:10:26PM -0500, Timur Tabi wrote:
> Why not?  I honestly don't know what x86 does, but I would think that if I 
> write a 32-bit value to a memory location, that when I examine that memory 
> location, all 32 bits will be in order.
> 
> You're talking about byte endian.  I'm talking about bit endian -- the 
> order of bits within a byte.  Software cannot know what the bit endian is, 
> but external devices that have memory-mapped registers can know.

The guy wiring up the hardware should connect the wires correctly.

> The CPU shift operation, yes.  I'm talking about shift operations on 
> external memory-mapped devices.

Doesn't the bus usually have some definition of bit order which the
device would have to adhere to?  After all there must be address lines
somewhere.

Does this perhaps offer anything useful?
http://www.linuxjournal.com/article/6788

--
Len Sorensen
