Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbYC0Ja3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbYC0Ja3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbYC0JaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:30:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53458 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbYC0JaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:30:19 -0400
Date: Thu, 27 Mar 2008 09:41:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: iommu breaks usb after resume
Message-ID: <20080327084126.GB25876@elf.ucw.cz>
References: <20080320111429.GA14764@elf.ucw.cz> <20080321135418.GB2346@one.firstfloor.org> <20080326102151.GB18965@elf.ucw.cz> <20080326130052.GF2170@one.firstfloor.org> <20080326225407.GA9378@elf.ucw.cz> <20080326230017.GA21017@elte.hu> <20080326230500.GB9378@elf.ucw.cz> <20080327055349.GC29105@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327055349.GC29105@one.firstfloor.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > (it is GPLed) ...but it is totally untested, and probably same fix
> > needs to go to all the agp drivers...?
> 
> No the other AGP drivers don't have IOMMU functionality.

Ok, good.

> Also there still need to be Kconfig changes or alternatively 
> extracting the suspend/resume code to another file that is selected
> by both AGP and IOMMU.

Well, it gets weirder. Boot messages are:

Checking aperture...
Node 0: aperture @ 0 size 32 MB
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM

...who is responsible for mapping aperture back during resume? It
seems like it is not amd64-agp: it does not find its hardware...?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
