Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0CGUtl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 15:49:41 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39573 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab0CGUtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 15:49:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AsHelYYfwyG5VqYX0GALg2iUR1zhRf50UoAePmuks3dcpYuT7Jf1Lt2ROsr8dumuj8
         dixQ2Q/0E8jHOXCQR7h7XTV7l+xt7P4W3K+MtK8s59F2TDR6QdfLTXie+8msFIP4dV6m
         bKUsVhE7VlXPmx5bckYeGBshE0oSigjoOaE1s=
Date: Sun, 7 Mar 2010 12:49:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dima Zavin <dmitriyz@google.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
Message-ID: <20100307204933.GC17727@core.coreip.homeip.net>
References: <4B8C1867.7040201@cam.ac.uk>
 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
 <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
 <20100303184132.GA11471@core.coreip.homeip.net>
 <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>
 <20100303190753.GB11471@core.coreip.homeip.net>
 <4B8EB99F.4080104@jic23.retrosnub.co.uk>
 <20100303230229.77df3ac3@hyperion.delvare>
 <404ea8001003031508p32641b2bj8781ce2b88e1f9cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <404ea8001003031508p32641b2bj8781ce2b88e1f9cb@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 03:08:29PM -0800, Dima Zavin wrote:
> 
> As it came up earlier in the thread, adding an ABS_AMBIENT_LIGHT_LEVEL
> or equivalent is much simpler and provides a clean, concise, and
> useful interface to userspace.
> 
> Note that for many applications, you actually get configurable
> threshold levels, and the hardware triggers an interrupt when the
> light level crosses those thresholds. This makes using an input device
> very useful, and that is in fact how we use ALS devices today. I have
> several pieces of hardware that do this, and I don't see how this new
> als subsystem helps me handle that problem. With the suggested API,
> I'll have to poll the sysfs files manually to see if they've changed
> (which is suboptimal), or still add a non-standard input device to do
> what I want.
>

OK, so from what you are saying it looks you just like the _interface_,
or transport, that input subsystem provides, not the fact that you
considering the device to be a HID-type device. If this is the case then
this indicates that we need to take another look at the proposed
interface and make sure that it allows proper poll() support.

-- 
Dmitry
