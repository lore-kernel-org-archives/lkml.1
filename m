Return-Path: <linux-kernel-owner+w=401wt.eu-S1751878AbXA0PaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbXA0PaI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 10:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbXA0PaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 10:30:08 -0500
Received: from mailhost.tue.nl ([131.155.2.19]:60979 "EHLO mailhost.tue.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbXA0PaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 10:30:06 -0500
X-Greylist: delayed 1411 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Jan 2007 10:30:06 EST
Date: Sat, 27 Jan 2007 16:06:32 +0100
From: Andries Brouwer <aebr@win.tue.nl>
To: =?utf-8?B?TWljaGHFgiBLdWTFgmE=?= <michal.kudla@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: KB->KiB, MB -> MiB, ... (IEC 60027-2)
Message-ID: <20070127150632.GA12688@win.tue.nl>
References: <200701200908.47654.Michal.Kudla@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200701200908.47654.Michal.Kudla@gmail.com>
User-Agent: Mutt/1.4.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 20, 2007 at 09:08:47AM +0100, Michał Kudła wrote:
> Hello,

> after 
> ...
> hdb: max request size: 512KiB
> hdb: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=30401/255/63, 
> 
> Should be everywere KiB, MiB, GiB, ... according to IEC 60027-2 

You are mistaken. The MB here are actual megabytes (million bytes), not MiB.
Read the code, or do the computation: 488397168*512 = 250059350016.

(Precisely what one wants - the kernel gives the correct size,
just like the disk manufacturers, and there is no discrepancy.
Binary abuse for decimal prefixes is a sloppiness that might be
acceptable for stuff that naturally comes in powers of two.
It is long ago that that was true for disks.)

Andries
