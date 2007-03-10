Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbXCJW0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbXCJW0t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932275AbXCJW0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:26:49 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48019 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932263AbXCJW0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:26:48 -0500
Date: Sat, 10 Mar 2007 23:26:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Johnson <ajohnson@intrinsyc.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Software Suspend: Fix suspend when console is in VT_AUTO/KD_GRAPHICS mode
Message-ID: <20070310222639.GE2674@elf.ucw.cz>
References: <1173394485.28589.17.camel@localhost.localdomain> <20070309090805.GA5822@atrey.karlin.mff.cuni.cz> <20070309153456.GA28664@srcf.ucam.org> <DBC923D919FAB345973A94E6E194E849043808E0@yvrmail01.itc.intrinsyc.com> <20070309211330.GC6374@ucw.cz> <1173477490.30345.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173477490.30345.9.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > ...how does qpe know when to repaint the screen, anyway?
> 
> QPE doesn't need to repaint the screen after wake-up - the framebuffer
> memory is retained so the PXA270 lcd controller simply displays what was
> last on the screen when it is re-enabled.

That probably means QPE is broken on machines that do not preserve
framebuffer over suspend :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
