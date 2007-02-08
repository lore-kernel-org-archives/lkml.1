Return-Path: <linux-kernel-owner+w=401wt.eu-S1752355AbXBHR5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbXBHR5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 12:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbXBHR5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 12:57:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53936 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbXBHR5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 12:57:02 -0500
Date: Thu, 8 Feb 2007 17:56:57 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: linux-fbdev-devel@lists.sourceforge.net
cc: Andrew Morton <akpm@osdl.org>, Dave Airlie <airlied@gmail.com>,
       Giuseppe Bilotta <giuseppe.bilotta@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
In-Reply-To: <20070207234837.GA27822@dreamland.darkstar.lan>
Message-ID: <Pine.LNX.4.64.0702081756270.7686@pentafluge.infradead.org>
References: <21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com>
 <20070128162907.370f5476.akpm@osdl.org> <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com>
 <cb7bb73a0701290637q2ce0ff16t28f82d0c0339a2ba@mail.gmail.com>
 <20070130203301.GA15067@dreamland.darkstar.lan> <20070204201713.GA12867@dreamland.darkstar.lan>
 <cb7bb73a0702041317u4ca2fbabp45cf56526e57c982@mail.gmail.com>
 <20070205201824.GA13431@dreamland.darkstar.lan>
 <cb7bb73a0702051328n50c889d9o461ac2bb9f9ea75e@mail.gmail.com>
 <Pine.LNX.4.64.0702062118450.9224@pentafluge.infradead.org>
 <20070207234837.GA27822@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > There is no stand alone nvidia card i2c driver. Its the issue of sharing 
> > device interfaces with the same hardware problem again!!! 
> 
> Nah, nvidiafb registers the I2C busses, you can drive them with whatever
> you want through the devices exported by I2C core.
> The fact the none of them work makes me think that the EDID is coming
> from the BIOS, we do VBE calls in real mode during early kernel setup.

What I meant is we can't load the i2c code seperate from the fbdev driver.

