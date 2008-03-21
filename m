Return-Path: <linux-kernel-owner+w=401wt.eu-S1764820AbYCUXIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764820AbYCUXIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932133AbYCUWwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:52:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43575 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131AbYCUWwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:52:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: APM crashes when IO is going on
Date: Fri, 21 Mar 2008 23:51:19 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <Pine.LNX.4.64.0803191608500.25941@artax.karlin.mff.cuni.cz> <200803212245.13659.rjw@sisk.pl> <Pine.LNX.4.64.0803212347430.25810@artax.karlin.mff.cuni.cz>
In-Reply-To: <Pine.LNX.4.64.0803212347430.25810@artax.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803212351.20186.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 21 of March 2008, Mikulas Patocka wrote:
> On Fri, 21 Mar 2008, Rafael J. Wysocki wrote:
> 
> > On Friday, 21 of March 2008, Mikulas Patocka wrote:
> > > > > I found another problem --- present in 2.6.23.1, 2.6.25rc3, 2.6.25rc6
> > > > > 
> > > > > --- when I run three threads concurrently reading raw disk partition and 
> > > > > suspend, I get 100% reproducible failure. (with one thread running it 
> > > > > usually succeeds, sometimes fail)
> > > > 
> > > > Are they userland threads or kernel threads?
> > > 
> > > Useland threads. Just dd if=/dev/hda of=/dev/null
> > > 
> > > > > Either the on-going I/O will jam BIOS and I need to remove power to 
> > > > > continue.
> > > > > 
> > > > > Or the machine suspends, wakes up and reports "hda: lost interrupt" 
> > > > > (2.6.23.1 was able to recover from this condition, 2.6.25rc3,6 does not 
> > > > > recover and it is not able to send any more disk IOs).
> > > > > 
> > > > > How is suspending disk IO supposed to work?
> > > > 
> > > > That depends on the driver, if I understand your question correctly.
> > > 
> > > The driver is normal IDE.
> > 
> > Do you mean IDE_GENERIC/BLK_DEV_GENERIC?
> 
> Compaq Triflex IDE. The computer is Compaq Armada 7400 (Pentium 2/300MHz)

Can you attach a dmesg output taken after a fresh boot?

Thanks,
Rafael
