Return-Path: <linux-kernel-owner+w=401wt.eu-S1763422AbYBLUhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763422AbYBLUhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbYBLUhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:37:10 -0500
Received: from www.tglx.de ([62.245.132.106]:39188 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbYBLUhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:37:09 -0500
Date: Tue, 12 Feb 2008 21:36:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Andi Kleen <ak@suse.de>, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/5] Only do century BCD conversion when we know the
 RTC is BCD
In-Reply-To: <20080211221514.GA12592@basil.nowhere.org>
Message-ID: <alpine.LFD.1.00.0802122130280.12988@apollo.tec.linutronix.de>
References: <20080209416.271135970@suse.de> <alpine.LFD.1.00.0802110924050.12988@apollo.tec.linutronix.de> <200802110956.16004.ak@suse.de> <alpine.LFD.1.00.0802112246590.12988@apollo.tec.linutronix.de> <20080211221514.GA12592@basil.nowhere.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, Andi Kleen wrote:

> > So the warning comes a bit late :)
> 
> I suspect if this was wrong before it would not have been noticed
> because user space hwclock would work around it. 

And how exaclty does it work around ? By setting the binary cmos clock
with BCD values ?

> The warning certainly won't hurt.

It won't.

> Anyways if you feel strongly about this (I don't) then drop
> this patch, but apply the other ones in the series. 

I'm not opposing the patch, I merily asked for a removal of the never
changing constant.

> The main one I consider important is the change to the 2000 offset
> for 32bit to extend the 32bit lifetime.

Picked the whole lot up.

Thanks,

	tglx
