Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbYF0NzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbYF0NzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbYF0NzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:55:09 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51723 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301AbYF0NzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:55:08 -0400
Date: Fri, 27 Jun 2008 15:55:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, monstr@seznam.cz,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 48/60] microblaze_v4: headers simple files - empty or redirect to asm-generic
Message-ID: <20080627135552.GA16485@uranus.ravnborg.org>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <200806261838.33787.arnd@arndb.de> <20080626180530.GA22827@cs181140183.pp.htv.fi> <200806270123.06669.arnd@arndb.de> <20080627115936.GA18644@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627115936.GA18644@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> We need either all architectures changed or none at all - we do need the 
> arch headers to become more similar, not more different.
> 
> And this is why we need an agreement _before_ an asm-generic header gets 
> added, not after it.
We already have the agreement..
Files which are equal among archs should be in asm-generic.
And there is simply no gain in adding files for an arch when can put
them in asm-generic.
When they are in asm-generic than we can fix the other archs one-by-one.

	Sam
