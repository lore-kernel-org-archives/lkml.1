Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbZGJMFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbZGJMFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbZGJMFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:05:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53295 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbZGJMFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:05:02 -0400
Date: Fri, 10 Jul 2009 01:19:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alexey Fisher <bug-track@fisher-privat.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Richard A. Holden III" <aciddeath@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Intel BIOS - Corrupted low memory at ffff880000004200
Message-ID: <20090709231936.GB1469@ucw.cz>
References: <4A5210A2.2080301@fisher-privat.net> <4A52254F.8080103@fisher-privat.net> <20090708113949.GA8960@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708113949.GA8960@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-07-08 12:39:49, Matthew Garrett wrote:
> On Mon, Jul 06, 2009 at 06:24:47PM +0200, Alexey Fisher wrote:
> > Hallo Ingo, Richard.
> >
> > I'm getting "Corrupted low memory" trace with my Intel DG45ID board
> > after resume. This board  has different dmi-bios-vendor... so probably
> > it will be nice to have it in your patch.
> 
> I'm beginning to think that we should be doing this on all hardware, 
> perhaps with a kernel option to disable it for embedded devices that 
> really need that 64K. The low-memory corruption issue seems to be very 
> widespread.

Well, maybe it would be better to make suspen/resume part of firmware
testing kit or  something... and push intel to fix their bios.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
