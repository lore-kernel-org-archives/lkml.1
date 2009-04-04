Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbZDDLDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbZDDLDd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 07:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbZDDLDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 07:03:23 -0400
Received: from hq2.tensilica.com ([65.205.227.30]:11210 "EHLO
	maia.hq.tensilica.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754496AbZDDLDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 07:03:22 -0400
Message-ID: <49D73E03.9040702@tensilica.com>
Date: Sat, 04 Apr 2009 04:01:23 -0700
From: Piet Delaney <piet.delaney@tensilica.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Johannes Weiner <jw@emlix.com>, Marc Gauthier <marc@tensilica.com>,
       Chris Zankel <chris@zankel.net>
CC: Piet Delaney <piet.delaney@gmail.com>,
       Piet Delaney <pdelaney@tensilica.com>, Cord Seele <cs@emlix.com>,
       Oskar Schirmer <os@emlix.com>, Daniel Gloeckner <dg@emlix.com>,
       Piet Delaney <piet@tensilica.com>,
       Maxim Grigoriev <maxim@tensilica.com>,
       Dan Nicolaescu <dann@tensilica.com>,
       Bill Huffman <huffman@tensilica.com>, Ross Morley <ross@tensilica.com>,
       Chris Jones <cjones@tensilica.com>, linux-xtensa@linux-xtensa.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dror Maydan <maydan@tensilica.com>
Subject: Re: [patch 0/8] xtensa: s6000 & s6105 - Git Repo Pulled; will try
 to merge early next week and get back to ya.
References: <20090319155621.GA8299@emlix.com> <49C36D94.9010809@tensilica.com> <20090322185756.GA11319@emlix.com> <49CA1EDD.1060806@tensilica.com> <20090325124749.GA15248@emlix.com> <49CA310C.6060504@gmail.com> <20090325153533.GA18835@emlix.com> <49CA8661.40804@gmail.com> <20090326120745.GA23541@emlix.com> <49CBE5B9.9020405@tensilica.com> <20090327141226.GA26597@emlix.com>
In-Reply-To: <20090327141226.GA26597@emlix.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:

>> What's you proposal?
> 
> Sounds terrific.  I wish you had told us this plan before, that would
> have saved us quite some discussion ;)
> 
> So please let us know where to find the merged tree when it's ready.
> We will test it on our S6000 board and look over your work.

I resolved the problems with the merge this evening and posted a
copy here and at kernel.org:

     git+ssh://git.linux-xtensa.org/git/kernel/xtensa-2.6.29-smp

     git://git.kernel.org/pub/scm/linux/kernel/git/piet/xtensa-2.6.29-smp.git

I have two SMP FPGA systems testing the merge, one with cache aliasing, the other
without. Both have been up now running NTP as a stress test for about two hours
without any problems. Earlier this evening I did have one problem when it was just
sitting idle; looked like a problem I had before and fixed.

I had one problem I've not worked around for now. In vmlinux.lds.in.S you added a
#include of <platform/hardware.h> put this causes compile problems for the LX60
platform. You added it to define KERNELOFFSET where as I was bringing it from
asm/core.h which caused less problems. <platform/hardware.h> seems reasonable,
haven't got a clean solution for the asm macro problem yet for LX60 platform.

Could you try this on your S6000 boards and look over our work. I'll
try using xt-gdb and ocd with the Stretch board. I likely have a few
minor tweaks in the Kconfig for _S6000 for selecting optimal defaults.


-piet







	
