Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbYKORaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbYKORaL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 12:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbYKOR36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 12:29:58 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33811 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751734AbYKOR35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 12:29:57 -0500
Date: Sat, 15 Nov 2008 18:29:45 +0100
From: Pavel Machek <pavel@suse.cz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Add WM8350 LED driver
Message-ID: <20081115172945.GC1523@ucw.cz>
References: <1226579997-3505-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226579997-3505-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-11-13 12:39:57, Mark Brown wrote:
> The voltage and current regulators on the WM8350 AudioPlus PMIC can be
> used in concert to provide a power efficient LED driver.  This driver
> implements support for this within the standard LED class.
> 
> Platform initialisation code should configure the LED hardware in the
> init callback provided by the WM8350 core driver.  The callback should
> use wm8350_isink_set_flash(), wm8350_dcdc25_set_mode() and
> wm8350_dcdc_set_slot() to configure the operating parameters of the
> regulators for their hardware and then then use wm8350_register_led() to
> instantiate the LED driver.

What kind of hw is this? 1W led attached to some kind of PDA?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
