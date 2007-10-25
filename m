Return-Path: <linux-kernel-owner+w=401wt.eu-S1760497AbXJYWqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760497AbXJYWqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbXJYWqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:46:15 -0400
Received: from sccrmhc14.comcast.net ([204.127.200.84]:46635 "EHLO
	sccrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbXJYWqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:46:14 -0400
Date: Thu, 25 Oct 2007 18:41:16 -0400 (EDT)
From: Parag Warudkar <kernel-stuff@comcast.net>
X-X-Sender: parag@parag-desktop
Reply-To: kernel-stuff@comcast.net
To: Ivo van Doorn <ivdoorn@gmail.com>
cc: rt2400-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Rt2400-devel] [PATCH] rt2500usb - Don't claim 050d:705{0/a}
In-Reply-To: <200710252315.49427.IvDoorn@gmail.com>
Message-ID: <alpine.DEB.0.99.0710251837040.9840@parag-desktop>
References: <alpine.DEB.0.99.0710241909250.18618@parag-desktop>
 <200710252315.49427.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ivo

On Thu, 25 Oct 2007, Ivo van Doorn wrote:

> I awknowledge the problem, but the solution cannot be found in the USB ID's
> listed in the driver. The bug is the manufacturer who changed chipset while
> keeping the USB ID the same.
> There are 2 possible ways around this: hacking the module loader so
> it continues searching for a different driver when the first driver indicates
> that it cannot control the device.
> Or the easiest way, just blacklist rt2500usb if you are sure you need the rt73 driver.

Thanks for the heads up - I think you have a good idea - there should be 
an interface between the loader and module to specify conditions like this.

I will see if I can generate interest in that idea and hack up something 
along the lines of your suggestion.

Parag
