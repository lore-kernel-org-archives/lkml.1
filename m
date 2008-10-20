Return-Path: <linux-kernel-owner+w=401wt.eu-S1752363AbYJTBE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbYJTBE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 21:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYJTBES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 21:04:18 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53680 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbYJTBES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 21:04:18 -0400
Date: Mon, 20 Oct 2008 02:04:16 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Andres Freund <andres@anarazel.de>
cc: Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] agp patches for 2.6.28-rc1.
In-Reply-To: <200810200300.01411.andres@anarazel.de>
Message-ID: <alpine.DEB.0.82.0810200202270.27788@skynet.skynet.ie>
References: <alpine.DEB.0.82.0810160758320.16504@skynet.skynet.ie>
 <200810200144.44383.andres@anarazel.de> <1224461977.5303.34.camel@koto.keithp.com>
 <200810200300.01411.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hm. But still, there is at least one distribution (ubuntu intrepid) which will 
> propably will ship 2.4.1 in its stable version soon (it seems unlikely that 
> they will update to an unstable version just before an release).
> Which means, that this driver will get quite some spread...

Intel will give the fixes to Ubuntu to roll into 2.4.x hopefully.

> Is it accepted that the kernel abi breaks that radically/fast?
> 

The problem is this isn't a kernel ABI at all. This is two pieces of code 
which are doing the exact same thing to a piece of hardware, one from the 
kernel and one from userspace. When they disagree things break, however 
sometimes when they agree things are broken. . The solution is proper 
kernel graphics drivers, however that future is further away.

Dave.

> Andres
> 
> 
