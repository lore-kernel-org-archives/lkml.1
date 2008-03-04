Return-Path: <linux-kernel-owner+w=401wt.eu-S1760757AbYCDJY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757AbYCDJY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 04:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbYCDJYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 04:24:13 -0500
Received: from gir.skynet.ie ([193.1.99.77]:43559 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbYCDJYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:24:10 -0500
Date: Tue, 4 Mar 2008 09:24:08 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jonathan McDowell <noodles@earth.li>, xorg-driver-ati@lists.x.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3 + RS690 + DRM + xf86-video-ati hang
In-Reply-To: <20080304011332.639a0551.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.0.82.0803040919370.22945@skynet.skynet.ie>
References: <20080301193511.GP9009@earth.li> <20080303224830.28e98b2b.akpm@linux-foundation.org>
 <alpine.DEB.0.82.0803040816180.24971@skynet.skynet.ie> <20080304085155.GX9009@earth.li>
 <20080304011332.639a0551.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > results in a machine that boots to GDM successfully. Likewise if I
> > disable CONFIG_DRM_RADEON in 2.6.25-rc3 the machine boots to GDM ok.
> 
> is what we wanted to know, thanks.  Surely it's a plain old regression?

Nope, its a userspace driver problem.. we have not released 
non-experimental code for that chipset, so its not surprising it fails 
when the kernel code gets run, but the fix most likely is in userspace not 
in the kernel.

I could disable the userspace DRI code but then where would I find my 
testers .. if he reads his Xorg log it says DRI is experimental on rs690 
and not to come crying..

this is the problem with adding new chipsets, I either wait for 6 months 
for all the bugs to get kicked out so nobody wins, or I push it upstream 
so most people win, I could back this out of the kernel, but experimental 
userspace code isn't  a reason for this..

Dave.
