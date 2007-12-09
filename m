Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbXLISGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbXLISGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 13:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbXLISFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 13:05:37 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1695 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750940AbXLISFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 13:05:35 -0500
Date: Sun, 9 Dec 2007 13:22:58 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "David P. Reed" <dpreed@reed.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
Message-ID: <20071209132258.GG4381@ucw.cz>
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <20071207160439.71b7f46a@the-village.bc.nu> <475AEF8E.5040906@reed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475AEF8E.5040906@reed.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2007-12-08 14:25:02, David P. Reed wrote:
> 
> 
> Alan Cox wrote:
> >
> >0x80 should be fine for anything PC compatible anyway, 
> >its specifically
> >reserved as a debug port and supported for *exactly* 
> >that purpose by
> >many chipsets.
> >
> >  
> Disagree. The definitions of PC compatible are quite 
> problematic.   I have the advantage over some of you 
> young guys, in that I actually wrote code on one of the 
> first 5 breadboard IBM PCs on the planet at Software 
> Arts, Inc. and I was directly involved in hardware spec 
> projects with the original IBM and Compaq engineers.  No 
> one actually defined the port numbered 80h as a 
> "standard" for anything.  You won't find it documented 
> in any early manual for an IBM machine.
> 
> The ISA bus supported unterminated transactions safely.  
> That allowed some clever folks to design BIOS diagnostic 
> tools that optionally plugged into the bus.
> 
> In any case, my machine does not have an ISA bus.  Why 
> should it?  It's a laptop!

There are mini-pci based cards with port 0x80 displays for notebooks.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
