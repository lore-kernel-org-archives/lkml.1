Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbYGKHU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbYGKHU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 03:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbYGKHUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 03:20:18 -0400
Received: from smtp1.versatel.nl ([62.58.50.88]:44543 "EHLO smtp1.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbYGKHUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 03:20:17 -0400
Message-ID: <48770B5E.7000308@hhs.nl>
Date: Fri, 11 Jul 2008 09:27:26 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Milton Miller <miltonm@bga.com>, linuxppc-dev@ozlabs.org,
       Samuel Ortiz <samuel@sortiz.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [RFC] (almost) booting allyesconfig -- please  don't poke super-io
 without request_region
References: <for-27-patch1-0@bga.com>	<48768018.2070704@hhs.nl>	<acca8e14e769b2feadee19f1f7448438@bga.com> <20080711085246.1ead773b@hyperion.delvare>
In-Reply-To: <20080711085246.1ead773b@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Hi Hans, hi Milton,
> 

<snip>

>> One could make a superio driver, and create sub-devices for the IR, 
>> I2C, floppy, parallel, etc
>> nodes.
> 
> There have been proposals to do this, and this would indeed be a very
> good idea, but unfortunately nobody took the time to implement this
> properly, push it upstream and volunteer to maintain it. The problem is
> that you don't need just a "driver", but a new subsystem, that needs to
> be designed and maintained.
> 

Well, I believe there have been some lightweight superio locking coordinator 
patches been floating around on the lm_sensors list, and I have reviewed them 
and then a new version was done with my issues fixed.

I kinda liked the proposed solution there, it was quite simple, moved all the 
generic superio stuff into generic superio code, and added locking for super io 
access from multiple drivers, what ever happened to those patches?

If were to start using those, we could actually do a request region and then 
never release it, as things should be.

Regards,

Hans
