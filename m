Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbXLOWfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbXLOWfm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 17:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbXLOWfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 17:35:33 -0500
Received: from hqemgate02.nvidia.com ([216.228.112.143]:3800 "EHLO
	HQEMGATE02.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbXLOWfc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 17:35:32 -0500
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Sat, 15 Dec 2007 14:34:25 -0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: More info on port 80 symptoms on MCP51 machine.
Date: Sat, 15 Dec 2007 14:34:24 -0800
Message-ID: <F72FA20C31DD4F4C997B91C5B3690A090263BC96@hqemmail07.nvidia.com>
In-Reply-To: <47604EA4.50504@zytor.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: More info on port 80 symptoms on MCP51 machine.
Thread-Index: Acg9BCaQUNtuDhyRQTGM7haEMi7djgCZY5GA
References: <475DE6F4.80702@zytor.com>	<475DEB23.1000304@davidnewall.com>	<20071211084059.3d03e11d@tux.DEF.witbe.net>	<475E5D4B.8020101@keyaccess.nl>	<475E7DC2.4060509@davidnewall.com>	<475E8D91.20201@keyaccess.nl>	<475E95A3.3070801@davidnewall.com>	<Pine.LNX.4.61.0712111024060.22976@chaos.analogic.com>	<20071211163017.GD16750@one.firstfloor.org>	<475EBFBA.6090301@keyaccess.nl>	<20071211191649.GB3437@elf.ucw.cz>	<475EEC75.80609@keyaccess.nl>	<47603F66.3070108@reed.com>	<476043DA.5000602@keyaccess.nl>	<47604B71.7090902@keyaccess.nl> <20071212210143.48721a41@the-village.bc.nu> <47604EA4.50504@zytor.com>
From: "Allen Martin" <AMartin@nvidia.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Rene Herman" <rene.herman@gmail.com>, "David P. Reed" <dpreed@reed.com>,
       "Pavel Machek" <pavel@ucw.cz>, "Andi Kleen" <andi@firstfloor.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       "David Newall" <david@davidnewall.com>, "Paul Rolland" <rol@as2917.net>,
       "Krzysztof Halasa" <khc@pm.waw.pl>, <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, <rol@witbe.net>
X-OriginalArrivalTime: 15 Dec 2007 22:34:24.0982 (UTC) FILETIME=[A5252F60:01C83F6A]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Alan Cox wrote:
> > On Wed, 12 Dec 2007 21:58:25 +0100
> > Rene Herman <rene.herman@gmail.com> wrote:
> > 
> >> On 12-12-07 21:26, Rene Herman wrote:
> >>
> >>> On 12-12-07 21:07, David P. Reed wrote:
> >>>> Someone might have an in to nVidia to clarify this, 
> since I don't.  
> >>>> In any case, the udelay(2) approach seems to be a safe 
> fix for this machine.
> >> By the way, _does_ anyone have a contact at nVidia who 
> could clarify? 
> >> Alan maybe? I'm quite curious what they did...
> > 
> > I don't. Nvidia are not the most open bunch of people on 
> the planet. 
> > This doesn't appear to be a chipset bug anyway but a firmware one 
> > (other systems with the same chipset work just fine).
> > 
> > The laptop maker might therefore be a better starting point.
> 
> One wonders if it does some SMM trick to capture port 0x80 
> writes and attempt to haul them off for debugging; it almost 
> sounds like some kind of debugging code got let out into the field.
> 
> 	-hpa

Nothing inside the chipset should be decoding port 80 writes.  It's 
possible this board has a port 80 decoder wired onto the board that's 
misbehaving.  I've seen other laptop boards with port 80 decoders
wired onto the board, even if the 7 segment display is only populated
on debug builds.  

We use PCI port 80 decoders internally for debugging quite often, so 
if there were some chipset issue related to port 80 it would have 
showed up a long time ago, and this is the first I've heard of
hangs related to port 80 writes.

-Allen
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
