Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbXIKPSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbXIKPSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 11:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbXIKPSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 11:18:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57421 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbXIKPSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 11:18:05 -0400
Date: Tue, 11 Sep 2007 16:18:03 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Jiri Slaby <jirislaby@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: X freezes kernel during exit [Re: 2.6.23-rc3-mm1]
In-Reply-To: <46E41601.7030600@gmail.com>
Message-ID: <Pine.LNX.4.64.0709111615310.10340@skynet.skynet.ie>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
 <46D17A7A.70609@gmail.com> <46D409FC.1070305@gmail.com> <46E3DCB8.5010709@gmail.com>
 <20070909054751.cbb27081.akpm@linux-foundation.org> <46E3FE6B.7010209@gmail.com>
 <20070909141730.GB25798@one.firstfloor.org> <46E4028E.9050007@gmail.com>
 <20070909143324.GC25798@one.firstfloor.org> <46E40699.7060000@gmail.com>
 <20070909150158.GD25798@one.firstfloor.org> <46E41601.7030600@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> What other info needed?

I'm seeing this on my 965gm chipset with Andi's clflush patches on x86 
32-bit, it looks like an interaction with the agp code which does a big 
bunch of change page attr to allocate the AGP aperture backed memory..

I think the code might have worked in a previous iteration on my 64-bit 
965G machine at home but I'm on the road and won't be back anytime soon..

I'll see what I can figure out from my laptop...

Dave.
