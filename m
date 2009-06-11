Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbZFKV2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbZFKV2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 17:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZFKV2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 17:28:32 -0400
Received: from 130.120.124.202.static.snap.net.nz ([202.124.120.130]:36923
	"EHLO hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752065AbZFKV2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 17:28:31 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jun 2009 17:28:31 EDT
Message-ID: <4A3175AC.9070100@bluewatersys.com>
Date: Fri, 12 Jun 2009 09:22:52 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Nicolas Pitre <nico@cam.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, swetland@google.com, pavel@ucw.cz,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
References: <20090611111821.GK795@n2100.arm.linux.org.uk>	<20090611.042226.28424489.davem@davemloft.net>	<20090611114911.GL795@n2100.arm.linux.org.uk>	<20090611.050030.169859977.davem@davemloft.net>	<20090611123852.GM795@n2100.arm.linux.org.uk>	<20090611135442.6b9ab315@lxorguk.ukuu.org.uk>	<20090611132134.GA11199@atomide.com>	<20090611133736.GP795@n2100.arm.linux.org.uk>	<20090611140038.GB11199@atomide.com>	<20090611140624.GS795@n2100.arm.linux.org.uk> <alpine.LFD.2.00.0906111314510.31536@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.0906111314510.31536@xanadu.home>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre wrote:
> On Thu, 11 Jun 2009, Russell King - ARM Linux wrote:
>
> I think that you, as the ARM maintainer, should continue gathering all 
> the ARM subarchitectures into a coherent ARM tree and arbitrate 
> conflicts when they occur.  You should especially keep a tight control 
> on the very core ARM code.  But everything under arch/arm/mach-* you 
> should let people maintaining those have control of that themselves and 
> free yourself from that responsibility as much as possible.  The current 
> directory structure is quite indicative of where the boundaries are 
> already.  This way, if I make a mess of arch/arm/mach-orion5x/* then you 
> just need to pass the blame straight to me.
> 

That works okay for the more popular sub-architectures like pxa, etc,
where there are a lot of people to review code and sort out issues
between themselves. However, for the architecture I do most of my work
on, ep93xx, there are basically two of us, Hartley and myself, doing
active work.

It seems a bit dodgy if all the patches to ep93xx are written by one of
us and acked by the other with no input from anybody else. It would be
very easy for the ep93xx code to become and complete mess, and lack any
coherency with the other sub-archs. I prefer having Russell, or somebody
else, at least have a glance at the patches before they get applied.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

       Ryan Mallon                              Unit 5, Amuri Park
       Phone: +64 3 3779127                     404 Barbadoes St
       Fax:   +64 3 3779135                     PO Box 13 889
       Email: ryan@bluewatersys.com             Christchurch, 8013
       Web:   http://www.bluewatersys.com       New Zealand
       Freecall Australia  1800 148 751         USA 1800 261 2934
