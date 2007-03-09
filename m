Return-Path: <linux-kernel-owner+w=401wt.eu-S1767544AbXCIVUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767544AbXCIVUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767542AbXCIVTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:19:53 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2217 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993145AbXCIVTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:19:43 -0500
Date: Fri, 9 Mar 2007 21:11:26 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrew Johnson <ajohnson@intrinsyc.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Software Suspend: Fix suspend when console is in VT_AUTO/KD_GRAPHICS mode
Message-ID: <20070309211125.GB6374@ucw.cz>
References: <1173394485.28589.17.camel@localhost.localdomain> <20070309090805.GA5822@atrey.karlin.mff.cuni.cz> <20070309153456.GA28664@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309153456.GA28664@srcf.ucam.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > So... if current console is graphical, we leave X accessing the
> > console... That's bad, because video state is not going to be
> > restored...?
> 
> A graphical console is not necessarily X. Is there any requirement for 
> there to be a single VT that isn't in text mode? The vt switching is 
> a hack, we shouldn't make life difficult for people who have their own 
> userspace code that's entirely capable of restoring video state on its 
> own.

How does their wonderful userspace code know that it needs to restore
video?

vt switch *does* mean 'kernel now takes over console'.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
