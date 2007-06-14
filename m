Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbXFNU0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbXFNU0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbXFNU0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:26:09 -0400
Received: from lucidpixels.com ([75.144.35.66]:59706 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbXFNU0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:26:08 -0400
Date: Thu, 14 Jun 2007 16:26:07 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
cc: Jesse Barnes <jesse.barnes@intel.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <4671992D.7060400@macroscoop.nl>
Message-ID: <Pine.LNX.4.64.0706141625260.26236@p34.internal.lan>
References: <200706071530.51552.jesse.barnes@intel.com> <4671992D.7060400@macroscoop.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jun 2007, Pim Zandbergen wrote:

> Thanks for this patch. I was having the exact same symptoms as Justin Piszcz, 
> on a different, but similar motherboard:
>
> Motherboard: GigaByte GA-G33-DS3R
> BIOS rev: F2
> Chipset: Intel G33
> Memory: 8GB
> Distro: Fedora 7 x86_64
> Kernel: kernel-2.6.21-1.3194.fc7
>
> Building vanilla 2.6.22-rc4 with your patch solved the problem.
>
> I'm now seeing this in the syslog
>
> ***************
> **** WARNING: likely BIOS bug
> **** MTRRs don't cover all of memory, trimmed 196608 pages
> ***************
>
> leaving me 7416672 kB of usable memory.
>
> If there's any way I can help with more info or testing,
> then let me know.
>
> Thanks,
> Pim
>

That's strange, I guess different chipsets 'chew' up different amounts of 
memory OR you have your DVT(?) (video-card memory/aperature) set to 256MB? 
I have mine set to 128MB, in top:

Mem:   8039576k total,  6187304k used,  1852272k free,      696k buffers

What type of memory are you using and what is your DVT set to?

Justin.
