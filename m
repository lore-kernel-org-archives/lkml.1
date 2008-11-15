Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbYKORoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbYKORoA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 12:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYKORnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 12:43:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34304 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751770AbYKORnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 12:43:52 -0500
Date: Sat, 15 Nov 2008 17:43:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Richard Purdie <rpurdie@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Add WM8350 LED driver
Message-ID: <20081115174350.GA12466@opensource.wolfsonmicro.com>
References: <1226579997-3505-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081115172945.GC1523@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081115172945.GC1523@ucw.cz>
X-Cookie: Be careful!  UGLY strikes 9 out of 10!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2008 at 06:29:45PM +0100, Pavel Machek wrote:
> On Thu 2008-11-13 12:39:57, Mark Brown wrote:

> > regulators for their hardware and then then use wm8350_register_led() to
> > instantiate the LED driver.

> What kind of hw is this? 1W led attached to some kind of PDA?

Depends on the hardware design - this is a generic component for battery
powered devices (including PDAs).  Typical applications include
relatively high power things like backlights.
