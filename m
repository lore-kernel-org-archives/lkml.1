Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbZIGNWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbZIGNWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 09:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZIGNWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 09:22:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52635 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbZIGNWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 09:22:19 -0400
Date: Mon, 7 Sep 2009 15:22:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/2] leds: Add WM831x status LED driver
Message-ID: <20090907132212.GA1739@ucw.cz>
References: <1252156161-10062-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1252156161-10062-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252156161-10062-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-09-05 14:09:21, Mark Brown wrote:
> The WM831x devices feature two software controlled status LEDs with
> hardware assisted blinking.
> 
> The device can also autonomously control the LEDs based on a selection
> of sources.  This can be configured at boot time using either platform
> data or the chip OTP.  A sysfs file in the style of that for triggers
> allowing the control source to be configured at run time.  Triggers
> can't be used here since they can't depend on the implementation details
> of a specific LED type.

I believe people *were* doing that with triggers in other drivers...?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
