Return-Path: <linux-kernel-owner+w=401wt.eu-S1757672AbXGBXIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbXGBXIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 19:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbXGBXIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 19:08:40 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48773 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755388AbXGBXIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 19:08:39 -0400
Date: Tue, 3 Jul 2007 01:08:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <ak@suse.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Indan Zupancic <indan@nul.nu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bwalle@suse.de
Subject: Re: blink driver power saving
Message-ID: <20070702230827.GA9071@elf.ucw.cz>
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net> <200707021351.57965.ak@suse.de> <d120d5000707020531y43d41b6fl46e05c8343dbbeae@mail.gmail.com> <200707021439.27357.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707021439.27357.ak@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-07-02 14:39:27, Andi Kleen wrote:
> 
> > > Perhaps one of you geniuses who all hate it can find a better way to
> > > solve the "video output dead after kexec; but need visual feedback to the user
> > > while crash dumping" problem. I'm waiting for your patches.
> > >
> > 
> > I don't don't like it ;) Unfortunately too many people end up enabling
> 
> Yes that's pretty weird. I admit I hadn't expected
> that problem. blink is equivalent to "annoy me" and it
> is a mystery why so many people should willingly ask their computer to 
> annoy them.

tristate "Keyboard blink driver"

...drivers are not expected to act on their own. I was expecting to
get nice /sys/class/led* interface to my keyboard leds.

BTW ... I still believe we should have /sys/class/led* interface to
those leds. I'd like to make them blink with hdd activity on some
machines... of course, that needs non-buggy KBC.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
