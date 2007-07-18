Return-Path: <linux-kernel-owner+w=401wt.eu-S935836AbXGRSpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935836AbXGRSpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbXGRSpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:45:06 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54607 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657AbXGRSpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:45:04 -0400
Date: Wed, 18 Jul 2007 20:45:02 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andi Kleen <andi@firstfloor.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Jonathan Campbell <jon@nerdgrounds.com>,
       linux-kernel@vger.kernel.org, torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
In-Reply-To: <20070718183840.GC3898@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0707182042580.5385@fbirervta.pbzchgretzou.qr>
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de>
 <469E3806.4030804@zytor.com> <20070718182021.GA3898@one.firstfloor.org>
 <Pine.LNX.4.64.0707182024231.5385@fbirervta.pbzchgretzou.qr>
 <20070718183840.GC3898@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 18 2007 20:38, Andi Kleen wrote:
>> >> 
>> >> Well, how big the vmlinux file is matters if it doesn't fit in memory
>> >> with enough time to get to the phase where it is dumping the init
>> >> sections.  
>> >
>> >If you don't have enough memory for a few tens of KB of init sections
>> >you're very unlikely to have enough memory for user space.
>> 
>> If the code was not too hackish, I would not buy that.
>> Routers for example can run -- minus the userspace utilities required to set
>> things up -- "without" userspace.
>
>They still need memory for packets and other data structures. 
>Without having enough memory to queue packets and keep the routing cache you cannot do 
>any useful routing.

And the hypothetical case where RAM is hotplugged and/or recognized after the
kernel has been loaded by the bootloader? I do not claim to be an expert, but
ASMP (http://lkml.org/lkml/2006/5/13/44) looks like RAM will join during
the kernel boot.


	Jan
-- 
