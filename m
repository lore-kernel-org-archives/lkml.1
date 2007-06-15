Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbXFOKfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbXFOKfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 06:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbXFOKez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 06:34:55 -0400
Received: from lucidpixels.com ([75.144.35.66]:44620 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbXFOKez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 06:34:55 -0400
Date: Fri, 15 Jun 2007 06:34:54 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <46726727.5090003@macroscoop.nl>
Message-ID: <Pine.LNX.4.64.0706150634320.26433@p34.internal.lan>
References: <200706071530.51552.jesse.barnes@intel.com> <4671992D.7060400@macroscoop.nl>
 <Pine.LNX.4.64.0706141625260.26236@p34.internal.lan> <46726727.5090003@macroscoop.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jun 2007, Pim Zandbergen wrote:

> Justin Piszcz wrote:
>> That's strange, I guess different chipsets 'chew' up different amounts of 
>> memory OR you have your DVT(?) (video-card memory/aperature) set to 256MB? 
>> I have mine set to 128MB, in top:
>> 
>> Mem:   8039576k total,  6187304k used,  1852272k free,      696k buffers
> Me:
> Mem:   7416672k total,   378988k used,  7037684k free,    13592k buffers
>
>> What type of memory are you using 
> 2x Kingston KVR667D2N5K2/4G
>> and what is your DVT set to?
> GigaByte's BIOS config options of the onboard graphics controller are
> very limited compared to those on your Intel motherboard.
>
> I can only choose the graphics buffer size, between
> "1MB+1~2MB for GTT" or "8MB+1~2MB for GTT".
> I chose the latter. The POST says 9MB are taken for video.
>
> Not that it matters much, as the current i810/intel xorg driver does
> not yet support the GMA3100, so I'm using the vesa driver.
>
> Thanks,
> Pim
>

I use the exact same memory model.  So it must be the difference in BIOS 
MTRR/E820 memory mappings.

Justin.
