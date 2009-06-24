Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZFXU4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZFXU4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbZFXU4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:56:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45615 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbZFXU4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:56:23 -0400
Date: Wed, 24 Jun 2009 22:56:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>, Russell King <rmk@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [ARM] msm: add minimal board file for HTC Dream
	device
Message-ID: <20090624205618.GD9149@elf.ucw.cz>
References: <1245033557-10968-1-git-send-email-swetland@google.com> <1245033557-10968-2-git-send-email-swetland@google.com> <1245033557-10968-3-git-send-email-swetland@google.com> <1245033557-10968-4-git-send-email-swetland@google.com> <20090615132248.GB14555@elf.ucw.cz> <a55d774e0906151125h36ee7c36yb9ecf5fb3fb8e41b@mail.gmail.com> <20090615182850.GA10490@elf.ucw.cz> <a55d774e0906151151p223895b1pc01be38e1d0e9358@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0906151151p223895b1pc01be38e1d0e9358@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-15 11:51:57, Brian Swetland wrote:
> On Mon, Jun 15, 2009 at 11:28 AM, Pavel Machek<pavel@ucw.cz> wrote:
> > (Now... I'm trying to figure out how leds are set up. It seems that
> > there are two classes -- leds-gpio, which is backlights, and 4colored
> > led. I'd like to use 4colored led for debugging... Unfortunately
> > drivers/leds/leds-cpld.c is quite "interesting" (and really abuses
> > interface at least with "blink" file). Is there easy way to turn some
> > light manually, best something that works early and can be used for
> > debugging?)
> 
> The 4color LED is controlled by an I2C led controller, so it's a bit
> of a pain to interact with very early on.
> 
> There are LED backlights behind the keyboard and the buttons on the
> "chin" of the device, controlled by the CPLD (see
> TROUT_GPIO_QTKEY_LED_EN and TROUT_GPIO_UI_LED_EN and and the cpld gpio
> stuff in board-trout-gpio.c).

Thanks, I got button backlight to blink. 

> This is actually another reason why I'd actually prefer to stick with
> trout at least inside the board-dream-* files... just a lot of code
> that uses this name that's we've been working with for a year or so.
> Renaming the files is trivial and updating the config options is easy
> too, but it gets to be a lot of shuffling around to keep changing the
> names internally.  A lot of hardware has names used be the
> developers/manufacturers/etc that don't match the product names (HTC
> calls "magic" sapphire, for example, and the board files reflect
> that), and of course these devices have different names in different
> markets too.

Well, there will be more readers/users than authors... But it does not
matter that much.

Are there any issues that prevent this from being merged? Russell, can
you take those patches?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
