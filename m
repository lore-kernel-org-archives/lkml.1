Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab0CFGxA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 01:53:00 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:52944 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751272Ab0CFGw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 01:52:58 -0500
Date: Sat, 6 Mar 2010 07:52:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, mgarski@post.pl, linux-input@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] Route kbd leds through the generic leds layer (3rd
 version)
Message-ID: <20100306065250.GD28759@elf.ucw.cz>
References: <20100224012010.GA4062@const>
 <20100225013840.GA5519@const.homenet.telecomitalia.it>
 <20100225102056.GG10823@core.coreip.homeip.net>
 <20100225214403.GB9378@const.homenet.telecomitalia.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100225214403.GB9378@const.homenet.telecomitalia.it>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-02-25 22:44:03, Samuel Thibault wrote:
> Dmitry Torokhov, le Thu 25 Feb 2010 02:20:56 -0800, a écrit :
> > I am aunsure about this patch. It ties all LEDs together
> 
> For now, yes.  There could be an additional per-device layer that the
> user could select instead, but my patch doesn't prevent that.

Well, having one LED device for all the keyboard leds, and separate
LED device for each of them indivudually would not be quite nice, and
once we have the "one for all" device, we can't really get rid of it.

> Being able to assign only some of the devices to the linux console
> would indeed probably be good, but to me it's just a refinement. Users
> a priori assume all keyboards get their leds updated, so my patch
> makes sense.  And it won't prevent a further patch that, in addition
> to input::<led> leds, adds per-device leds, which the user could use
> instead of input::<led>.

As I said, having both is ugly... but the triggers could / should be
merged now...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
