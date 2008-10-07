Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbYJGVRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbYJGVRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbYJGVRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:17:39 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42580 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbYJGVRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:17:39 -0400
Date: Tue, 7 Oct 2008 23:19:17 +0200
From: Pavel Machek <pavel@suse.cz>
To: Mark Brown <broonie@sirena.org.uk>
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH V3] led: Backlight trigger for led subsystem
Message-ID: <20081007211917.GJ6604@elf.ucw.cz>
References: <1223374230-18413-1-git-send-email-giometti@enneenne.com> <20081007135420.GB1592@ucw.cz> <20081007152032.GH13035@tekkaman> <20081007185846.GA6604@elf.ucw.cz> <20081007192112.GL13035@tekkaman> <20081007195648.GD6604@elf.ucw.cz> <20081007201954.GM13035@tekkaman> <20081007203946.GA3514@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007203946.GA3514@sirena.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-10-07 21:39:46, Mark Brown wrote:
> On Tue, Oct 07, 2008 at 10:19:54PM +0200, Rodolfo Giometti wrote:
> > On Tue, Oct 07, 2008 at 09:56:48PM +0200, Pavel Machek wrote:
> 
> > > Hmm, what's "your board"?
> 
> > Sorry, I meant "my custom board". :) It's PXA270 based but it's not
> > into Linux main tree.
> 
> Another example, support for which should be coming shortly, is the LED
> driver provided by the WM8350: this is a PMIC capable of producing outputs
> to drive LEDs, potentially strings of very bright LEDs.  This is frequently
> used to illuminate displays but the actual function depends entirely on how
> the system has been wired up.
> 
> The implementation is identical no matter what the LEDs are doing but the
> current out of tree drivers have two drivers for this bit of the hardware,
> one for use in the normal LED case and one for when used as a backlight,
> which is redundnant.  With the driver Rodolfo has written this should no
> longer be required and the backlight trigger can be used to share the
> hardware interface code.

Well, Rodolfo's patch will not allow you to set backlight brightness,
only on/off, right?

So if your leds are really a backlight, you still should use backlight
class directly...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
