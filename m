Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbXCUMfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbXCUMfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 08:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbXCUMfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 08:35:53 -0400
Received: from lazybastard.de ([212.112.238.170]:57063 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbXCUMfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 08:35:52 -0400
Date: Wed, 21 Mar 2007 13:31:36 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Matt Mackall <mpm@selenic.com>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
Message-ID: <20070321123136.GA495@lazybastard.org>
References: <20070319170838.GP4892@waste.org> <1174328188.30079.46.camel@zod.rchland.ibm.com> <20070319195442.GT4892@waste.org> <1174338329.13341.633.camel@localhost.localdomain> <20070319223205.GZ4892@waste.org> <1174351366.13341.739.camel@localhost.localdomain> <20070321110528.GC3785@lazybastard.org> <1174476334.10840.49.camel@localhost.localdomain> <20070321113523.GD3785@lazybastard.org> <1174478263.10840.56.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1174478263.10840.56.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 March 2007 12:57:42 +0100, Thomas Gleixner wrote:
> On Wed, 2007-03-21 at 12:35 +0100, Jörn Engel wrote:
> > Even if such flashes still contain a bootloader and a kernel, that will
> > occupy less than 1% of the device.  Wear leveling across the device is
> > fairly pointless here.  This is what I designed LogFS for.
> 
> Still you need to have a solution for handling bitflips in those
> bootloader and kernel areas.

Correct.  It may make sense to use UBI for that, I don't know.  What I
do know is that UBI cannot make wear leveling decisions as well as
LogFS.

And that is all I care about wrt. this discussion.

Jörn

-- 
Joern's library part 8:
http://citeseer.ist.psu.edu/plank97tutorial.html
