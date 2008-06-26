Return-Path: <linux-kernel-owner+w=401wt.eu-S1761384AbYFZSId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384AbYFZSId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760865AbYFZSHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:07:43 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:35088 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756722AbYFZSHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:07:41 -0400
Date: Thu, 26 Jun 2008 21:05:30 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: monstr@seznam.cz, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 48/60] microblaze_v4: headers simple files - empty or
	redirect to asm-generic
Message-ID: <20080626180530.GA22827@cs181140183.pp.htv.fi>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <200806261735.12738.arnd@arndb.de> <20080626162118.GG22025@cs181140183.pp.htv.fi> <200806261838.33787.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200806261838.33787.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 06:38:32PM +0200, Arnd Bergmann wrote:
> On Thursday 26 June 2008, Adrian Bunk wrote:
> > The comment could be nuked (as well as the #ifdef __KERNEL__), but for 
> > the one #define an asm-generic header would IMHO be overkill.
> 
> I agree that it doesn't technically make sense to have a one-line
> asm-generic header, but I like the idea of reducing the number of
> asm/*.h files that actually contain anything other that
> #include <asm-generic/$FILE.h>, mostly for documentation purposes.
> 
> If we can eventually agree on a way to get rid of the requirement
> for explicit redirection, we can remove a larger number of source
> files completely.

Honestly, I do not completely like your approach of getting the 
microblaze port submitter to create the asm-generic files - I would 
personally prefer if the microblaze port would look exactly like all 
other ports and the (reasonable) changes you have in mind were not
being discussed and done as part of the submission of a new port.

After all, it won't matter whether we'll unify resp. remove
22 or 23 files.

> 	Arnd <><

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

