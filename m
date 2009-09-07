Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbZIGNvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbZIGNvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 09:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbZIGNvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 09:51:06 -0400
Received: from dan.rpsys.net ([93.97.175.187]:52584 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbZIGNvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 09:51:05 -0400
Subject: Re: [PATCH 2/2] leds: Add WM831x status LED driver
From: Richard Purdie <rpurdie@rpsys.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <20090907132212.GA1739@ucw.cz>
References: <1252156161-10062-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1252156161-10062-2-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <20090907132212.GA1739@ucw.cz>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 14:51:24 +0100
Message-Id: <1252331484.17852.50.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 15:22 +0200, Pavel Machek wrote:
> On Sat 2009-09-05 14:09:21, Mark Brown wrote:
> > The WM831x devices feature two software controlled status LEDs with
> > hardware assisted blinking.
> > 
> > The device can also autonomously control the LEDs based on a selection
> > of sources.  This can be configured at boot time using either platform
> > data or the chip OTP.  A sysfs file in the style of that for triggers
> > allowing the control source to be configured at run time.  Triggers
> > can't be used here since they can't depend on the implementation details
> > of a specific LED type.
> 
> I believe people *were* doing that with triggers in other drivers...?

We did talk about allowing the LED triggers to choose whether they were
visible to a given LED. At present the mechanism doesn't exist because
we've never had a user.

It would just be a case of adding a new optional function to the trigger
to say whether it supported a given LED or not and calling that function
from led_trigger_show().

I've queued this driver but that would be a nice enhancement.

Cheers,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

