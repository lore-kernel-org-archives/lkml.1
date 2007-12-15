Return-Path: <linux-kernel-owner+w=401wt.eu-S1761691AbXLOXG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761691AbXLOXG5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 18:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbXLOXGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 18:06:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45793 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbXLOXGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 18:06:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Sun, 16 Dec 2007 00:26:19 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Michael Buesch <mb@bu3sch.de>, Daniel Walker <dwalker@mvista.com>,
       akpm@linux-foundation.org, stefano.brivio@polimi.it,
       Ray Lee <ray-lk@madrabbit.org>, matthias.kaehlcke@gmail.com,
       linux-kernel@vger.kernel.org, mbuesch@freenet.de, linux@bohmer.net,
       kjwinchester@gmail.com, jonathan@jonmasters.org,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       bcm43xx-dev@lists.berlios.de
References: <20071213003028.676998182@mvista.com> <200712150225.52183.rjw@sisk.pl> <20071215214300.GC3096@tuxdriver.com>
In-Reply-To: <20071215214300.GC3096@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712160026.20730.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 15 of December 2007, John W. Linville wrote:
> On Sat, Dec 15, 2007 at 02:25:50AM +0100, Rafael J. Wysocki wrote:
> > On Friday, 14 of December 2007, Michael Buesch wrote:
> 
> > > Either distributions have to install it automatically or people simply have
> > > to read one or two lines of documentation.  That's just what I wanted to say.
> > 
> > It's not that simple.  For example, regression testing will be a major PITA
> > if one needs to switch back and forth from the new driver to the old one in the
> > process.
> 
> Not really true -- a single system can easily have firmware installed
> for b43, b43legacy, and bcm43xx at the same time and switch back and
> forth between them.
> 
> Given a functioning udev configuration, the persistent naming even
> works so that your device stays as 'eth1' when switching to and
> fro bcm43xx.

Well, this last bit doesn't work on my openSUSE 10.3.  Honest, guv. ;-)

> I really think everyone is overstating the problem.

You might be right.

Greetings,
Rafael
 
