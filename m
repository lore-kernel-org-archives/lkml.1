Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbYJ0NDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbYJ0NDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 09:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYJ0NDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 09:03:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44945 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbYJ0NDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 09:03:45 -0400
Date: Mon, 27 Oct 2008 14:03:44 +0100
From: Pavel Machek <pavel@suse.cz>
To: Thomas Renninger <trenn@suse.de>
Cc: Eric Piel <eric.piel@tremplin-utc.net>, akpm@linux-foundation.org,
       burman.yan@gmail.com, rpurdie@rpsys.net,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Kay Sievers <kasievers@suse.de>, hmh@hmh.eng.br
Subject: Re: leds-hp-disk vs lis3lv02d
Message-ID: <20081027130343.GB14829@atrey.karlin.mff.cuni.cz>
References: <200810162255.m9GMtKj4001733@imap1.linux-foundation.org> <4902F817.4050108@tremplin-utc.net> <20081026174023.GA1847@ucw.cz> <200810271345.04961.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810271345.04961.trenn@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > OTOH  it should 
> > not block merge; both drivers still work and are useful.
> But for long-term the HPQ0004 specific things in the lids3v driver should get 
> merged with your HP leds driver also registering for HPQ0004 and the lids3v 
> specific things should get a separate driver which HPQ0004 driver makes use 
> of?

Yep, that sounds sane.

> Pavel: I am also not sure whether it's a good idea to mis-use the HP's LED for 
> mail notification or similar or to expose this one as a general LED. This LED 
> is intended to be used with the disk parking feature by the vendor?
> I don't know the LED interface well, but if it's now possible that
> every mail 

That's how LED interface works. This _is_ general LED.

Check permissions in /sys; root  permissons should be needed to
blink the LED.

> or other app can reprogram the disk parking LED for it's own purposes, this 
> sounds wrong. The LED can still be accessed and activated, e.g. when disk 
> gets parked behind the OS'es back. If this is a nice hack to e.g. use LED for 
> suspend debugging or similar, then it should be well hidden to the outside 
> world.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
