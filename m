Return-Path: <linux-kernel-owner+w=401wt.eu-S965531AbXBFWG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965531AbXBFWG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965511AbXBFWG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:06:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39561 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965496AbXBFWG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:06:27 -0500
Date: Tue, 6 Feb 2007 22:06:22 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
cc: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] RFC: Cell SPE logos
In-Reply-To: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be>
Message-ID: <Pine.LNX.4.64.0702062201430.3088@pentafluge.infradead.org>
References: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I would like to hear your opinions about the patchset below (updated version
> compared to yesterday, lkml added to the CC list).
> 
> The Cell Broadband Engine contains a 64-bit PowerPC core with 2 hardware
> threads (called PPEs) and 8 Synergistic Processing Engines (called SPEs).
> When booting Linux, 2 penguins logos are shown on the graphical console by
> the standard frame buffer console logo code.
> 
> To emphasize the existence of the SPEs (which can be used under Linux), we
> added a second row of (smaller) helper penguin logos, one for each SPE.
> I attached a PNG version of the helper penguin logo for reference.
> 
> Summaries:
> [PATCH 1/7] fbdev: Avoid vertical overflow when making space for the logo
> [PATCH 2/7] fbdev: fb_do_show_logo() updates
> [PATCH 3/7] fbdev: extract fb_show_logo_line()
> [PATCH 4/7] fbdev: move logo externs to header file
> [PATCH 5/7] fbdev: Add fb_append_extra_logo()
> [PATCH 6/7] fbdev: SPE helper penguin logo
> [PATCH 7/7] Cell: Draw SPE helper penguin logos
> 
> Thanks for your comments!

    Now that their are patches for the logo I would like to see a few more 
improvements that I haven't gotten too. I really like to see the logo 
drawn outside of fbcon. This way for embedded platforms without fbcon we 
could have the logo to know if the graphics device worked.

