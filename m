Return-Path: <linux-kernel-owner+w=401wt.eu-S1758316AbXLOWAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316AbXLOWAb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 17:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbXLOWAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 17:00:23 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:3545 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbXLOWAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 17:00:22 -0500
Date: Sat, 15 Dec 2007 16:43:00 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Michael Buesch <mb@bu3sch.de>, Daniel Walker <dwalker@mvista.com>,
       akpm@linux-foundation.org, stefano.brivio@polimi.it,
       Ray Lee <ray-lk@madrabbit.org>, matthias.kaehlcke@gmail.com,
       linux-kernel@vger.kernel.org, mbuesch@freenet.de, linux@bohmer.net,
       kjwinchester@gmail.com, jonathan@jonmasters.org,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
	to mutex
Message-ID: <20071215214300.GC3096@tuxdriver.com>
References: <20071213003028.676998182@mvista.com> <20071214175910.GA27078@elte.hu> <200712141938.10733.mb@bu3sch.de> <200712150225.52183.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712150225.52183.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2007 at 02:25:50AM +0100, Rafael J. Wysocki wrote:
> On Friday, 14 of December 2007, Michael Buesch wrote:

> > Either distributions have to install it automatically or people simply have
> > to read one or two lines of documentation.  That's just what I wanted to say.
> 
> It's not that simple.  For example, regression testing will be a major PITA
> if one needs to switch back and forth from the new driver to the old one in the
> process.

Not really true -- a single system can easily have firmware installed
for b43, b43legacy, and bcm43xx at the same time and switch back and
forth between them.

Given a functioning udev configuration, the persistent naming even
works so that your device stays as 'eth1' when switching to and
fro bcm43xx.  I really think everyone is overstating the problem.

John
-- 
John W. Linville
linville@tuxdriver.com
