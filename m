Return-Path: <linux-kernel-owner+w=401wt.eu-S932261AbXA2KdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbXA2KdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 05:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbXA2Kch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 05:32:37 -0500
Received: from mail.first.fraunhofer.de ([194.95.169.2]:52219 "EHLO
	mail.first.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbXA2Kc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 05:32:26 -0500
Subject: Re: 2.6.20-rc6 pb_fnmode regression
From: Soeren Sonnenburg <kernel@nn7.de>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.64.0701291049190.9448@twin.jikos.cz>
References: <1169904555.2462.10.camel@localhost>
	 <Pine.LNX.4.64.0701291049190.9448@twin.jikos.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Jan 2007 11:32:17 +0100
Message-Id: <1170066737.13904.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-29 at 10:55 +0100, Jiri Kosina wrote:
> On Sat, 27 Jan 2007, Soeren Sonnenburg wrote:
> 
> > I realized that any setting to /sys/module/usbhid/parameters/pb_fnmode 
> > is just ignored until the machine does a suspend-resume cycle.
[...]
> I would rather be inclined to just make the 
> /sys/module/usbhid/parameters/pb_fnmode read-only (which is what most of 
> the drivers do anyway), to avoid this kind of confusion.
> 
> Do you have really any strong use-case, when setting the parameter during 
> runtime would be much more useful than just do it during modprobe or 
> rmmod/modprobe cycle?

Well I need in-kernel usbhid and the way this was implemented in 2.6.19
(and before) one could change pb_fnmode on-the-fly. This is mentioned in
all the power/i/mac/book tutorials and everyone is used to switching
modes this way.

I can happily patch the kernel to use the pb_fnmode but nonetheless this
is a regression to pre 2.6.20* and will confuse others too...

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
