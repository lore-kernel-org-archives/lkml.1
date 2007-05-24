Return-Path: <linux-kernel-owner+w=401wt.eu-S1760862AbXEXAWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862AbXEXAWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbXEXAWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:22:48 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756331AbXEXAWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:22:48 -0400
Date: Wed, 23 May 2007 17:21:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Olivier Galibert <galibert@pobox.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
In-Reply-To: <200705231555.07683.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.0.98.0705231709220.3890@woody.linux-foundation.org>
References: <4635510D.4060103@shaw.ca> <20070523222443.GA39776@dspnet.fr.eu.org>
 <alpine.LFD.0.98.0705231536510.3890@woody.linux-foundation.org>
 <200705231555.07683.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 May 2007, Jesse Barnes wrote:
> 
> After I sent my last message I realized the same thing... though I 
> occasionally hear people talk about removing it (I seriously doubt that 
> will ever happen).  I don't even think there's a way to disable type 1 
> config access on Intel chipsets...

Considering that the chipsets still have support for features that 
*really* aren't used (and haven't been used in over a decade), I doubt the 
conf1 thing is going away any time soon.

Things like: A20 gate, 15-16MB holes, i387 FP exception on irq 13 are 
totally pointless in this day and age. Things like the DMA controller are 
getting there, along with PS/2 keyboard support.

So there's a lot of things that are likely to be removed before conf1 
accesses would. Removing CONF1 accesses would break every single current 
OS, they'll do that ten years from now at the earliest.

			Linus
