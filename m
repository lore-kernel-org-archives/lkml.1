Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbZIIJKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbZIIJKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbZIIJKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:10:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:4383 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbZIIJKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:10:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,357,1249282800"; 
   d="scan'208";a="446955387"
Date: Wed, 9 Sep 2009 11:12:42 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Pavel Machek <pavel@ucw.cz>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] leds: Add WM831x status LED driver
Message-ID: <20090909091239.GA4292@sortiz.org>
References: <1252156161-10062-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1252156161-10062-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20090907132212.GA1739@ucw.cz>
 <1252331484.17852.50.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252331484.17852.50.camel@dax.rpnet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Mon, Sep 07, 2009 at 02:51:24PM +0100, Richard Purdie wrote:
> On Mon, 2009-09-07 at 15:22 +0200, Pavel Machek wrote:
> > On Sat 2009-09-05 14:09:21, Mark Brown wrote:
> > > The WM831x devices feature two software controlled status LEDs with
> > > hardware assisted blinking.
> > > 
> > > The device can also autonomously control the LEDs based on a selection
> > > of sources.  This can be configured at boot time using either platform
> > > data or the chip OTP.  A sysfs file in the style of that for triggers
> > > allowing the control source to be configured at run time.  Triggers
> > > can't be used here since they can't depend on the implementation details
> > > of a specific LED type.
> > 
> > I believe people *were* doing that with triggers in other drivers...?
> 
> We did talk about allowing the LED triggers to choose whether they were
> visible to a given LED. At present the mechanism doesn't exist because
> we've never had a user.
> 
> It would just be a case of adding a new optional function to the trigger
> to say whether it supported a given LED or not and calling that function
> from led_trigger_show().
> 
> I've queued this driver but that would be a nice enhancement.
Unless you're basing your tree on linux-next, you may have issues applying
this patch since the wm831x header is not in Linus tree yet.
If you have troubles with this patch, let me know and I'll queue it.

Cheers,
Samuel.


> Cheers,
> 
> Richard
> 
> -- 
> Richard Purdie
> Intel Open Source Technology Centre
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
