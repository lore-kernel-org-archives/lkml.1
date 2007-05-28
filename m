Return-Path: <linux-kernel-owner+w=401wt.eu-S1761333AbXE1IGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761333AbXE1IGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757168AbXE1IGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:06:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56434 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbXE1IGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:06:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
Date: Mon, 28 May 2007 10:11:15 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
References: <1180008394.15600.26.camel@localhost> <20070527184402.GA21161@srcf.ucam.org> <20070528010506.GA24186@srcf.ucam.org>
In-Reply-To: <20070528010506.GA24186@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281011.17338.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 May 2007 03:05, Matthew Garrett wrote:
> On Sun, May 27, 2007 at 07:44:02PM +0100, Matthew Garrett wrote:
> 
> > Anyway. I've tested the following patch on a dual-core x86. No obvious 
> > issues yet, but I'll try to put it through a few hundred cycles.
> 
> This /mostly/ works - I've had my test machine cycling through a suspend 
> cycle every 10 seconds for the past hour without any difficulties 
> providing I unload USB first. If USB is loaded, the suspend occasionally 
> fails with one of the devices returning -EBUSY and causing it to be 
> aborted. I haven't looked into this in any detail yet, but it's 
> presumably sufficiently generic code that it's potentially biting people 
> on PPC anyway.

Most probably.

Still, please take what I said in the other thread into consideration: We've
been using the freezer for so long that at least some drivers started to rely
on it being used.

Even if there are no such drivers on your system, they can be used by other
systems.

Greetings,
Rafael
