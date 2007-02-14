Return-Path: <linux-kernel-owner+w=401wt.eu-S1750976AbXBNRdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750976AbXBNRdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 12:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbXBNRdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 12:33:14 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:38115 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750954AbXBNRdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 12:33:14 -0500
Date: Wed, 14 Feb 2007 18:33:12 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: James Simmons <jsimmons@infradead.org>
cc: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 0/7] RFC: Cell SPE logos
In-Reply-To: <Pine.LNX.4.64.0702132049030.898@pentafluge.infradead.org>
Message-ID: <Pine.LNX.4.62.0702141832400.2949@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be>
 <Pine.LNX.4.62.0702121452480.4624@pademelon.sonytel.be>
 <Pine.LNX.4.64.0702132049030.898@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007, James Simmons wrote:
> Andrew please apply. 

Thanks!

Andrew, I will resend the whole series again, against current linus.git.

> Acked-By: James Simmons <jsimmons@infradead.org>
> 
> On Mon, 12 Feb 2007, Geert Uytterhoeven wrote:
> 
> > On Wed, 31 Jan 2007, Geert Uytterhoeven wrote:
> > > I would like to hear your opinions about the patchset below (updated version
> > > compared to yesterday, lkml added to the CC list).
> > > 
> > > The Cell Broadband Engine contains a 64-bit PowerPC core with 2 hardware
> > > threads (called PPEs) and 8 Synergistic Processing Engines (called SPEs).
> > > When booting Linux, 2 penguins logos are shown on the graphical console by
> > > the standard frame buffer console logo code.
> > > 
> > > To emphasize the existence of the SPEs (which can be used under Linux), we
> > > added a second row of (smaller) helper penguin logos, one for each SPE.
> > > I attached a PNG version of the helper penguin logo for reference.
> > > 
> > > Summaries:
> > > [PATCH 1/7] fbdev: Avoid vertical overflow when making space for the logo
> > > [PATCH 2/7] fbdev: fb_do_show_logo() updates
> > > [PATCH 3/7] fbdev: extract fb_show_logo_line()
> > > [PATCH 4/7] fbdev: move logo externs to header file
> > > [PATCH 5/7] fbdev: Add fb_append_extra_logo()
> > > [PATCH 6/7] fbdev: SPE helper penguin logo
> > > [PATCH 7/7] Cell: Draw SPE helper penguin logos

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
