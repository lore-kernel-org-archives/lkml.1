Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbXGCFmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbXGCFmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 01:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbXGCFmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 01:42:36 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:32858 "EHLO
	asav01.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbXGCFmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 01:42:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtYjAMd+iUZKhRO4R2dsb2JhbACBT4Vch3IBARsNBhEB
From: Dmitry Torokhov <dtor@insightbb.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: blink driver power saving
Date: Tue, 3 Jul 2007 01:42:35 -0400
User-Agent: KMail/1.9.3
Cc: Andi Kleen <ak@suse.de>, Indan Zupancic <indan@nul.nu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bwalle@suse.de
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net> <200707021439.27357.ak@suse.de> <20070702230827.GA9071@elf.ucw.cz>
In-Reply-To: <20070702230827.GA9071@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707030142.36252.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 July 2007 19:08, Pavel Machek wrote:
> On Mon 2007-07-02 14:39:27, Andi Kleen wrote:
> > 
> > > > Perhaps one of you geniuses who all hate it can find a better way to
> > > > solve the "video output dead after kexec; but need visual feedback to the user
> > > > while crash dumping" problem. I'm waiting for your patches.
> > > >
> > > 
> > > I don't don't like it ;) Unfortunately too many people end up enabling
> > 
> > Yes that's pretty weird. I admit I hadn't expected
> > that problem. blink is equivalent to "annoy me" and it
> > is a mystery why so many people should willingly ask their computer to 
> > annoy them.
> 
> tristate "Keyboard blink driver"
> 
> ...drivers are not expected to act on their own. I was expecting to
> get nice /sys/class/led* interface to my keyboard leds.
> 
> BTW ... I still believe we should have /sys/class/led* interface to
> those leds. I'd like to make them blink with hdd activity on some
> machines... of course, that needs non-buggy KBC.

I'll take patches. Ofcourse we'll have to keep the current EV_LED interface
for compatibility.

-- 
Dmitry
