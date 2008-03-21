Return-Path: <linux-kernel-owner+w=401wt.eu-S1763402AbYCUWxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763402AbYCUWxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762494AbYCUWtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:49:09 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:58148 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763445AbYCUWtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:49:07 -0400
Date: Fri, 21 Mar 2008 23:49:06 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: APM crashes when IO is going on
In-Reply-To: <200803212245.13659.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0803212347430.25810@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0803191608500.25941@artax.karlin.mff.cuni.cz>
 <200803212215.54854.rjw@sisk.pl> <Pine.LNX.4.64.0803212216540.16100@artax.karlin.mff.cuni.cz>
 <200803212245.13659.rjw@sisk.pl>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Rafael J. Wysocki wrote:

> On Friday, 21 of March 2008, Mikulas Patocka wrote:
> > > > I found another problem --- present in 2.6.23.1, 2.6.25rc3, 2.6.25rc6
> > > > 
> > > > --- when I run three threads concurrently reading raw disk partition and 
> > > > suspend, I get 100% reproducible failure. (with one thread running it 
> > > > usually succeeds, sometimes fail)
> > > 
> > > Are they userland threads or kernel threads?
> > 
> > Useland threads. Just dd if=/dev/hda of=/dev/null
> > 
> > > > Either the on-going I/O will jam BIOS and I need to remove power to 
> > > > continue.
> > > > 
> > > > Or the machine suspends, wakes up and reports "hda: lost interrupt" 
> > > > (2.6.23.1 was able to recover from this condition, 2.6.25rc3,6 does not 
> > > > recover and it is not able to send any more disk IOs).
> > > > 
> > > > How is suspending disk IO supposed to work?
> > > 
> > > That depends on the driver, if I understand your question correctly.
> > 
> > The driver is normal IDE.
> 
> Do you mean IDE_GENERIC/BLK_DEV_GENERIC?

Compaq Triflex IDE. The computer is Compaq Armada 7400 (Pentium 2/300MHz)

Mikulas

> Rafael
> 
