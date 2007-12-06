Return-Path: <linux-kernel-owner+w=401wt.eu-S1751160AbXLFMWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160AbXLFMWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbXLFMVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:21:53 -0500
Received: from styx.suse.cz ([82.119.242.94]:53917 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752576AbXLFMVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:21:52 -0500
Date: Thu, 6 Dec 2007 13:21:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Diego Zuccato <diego@otello.alma.unibo.it>
Cc: Jeff Garzik <jeff@garzik.org>, Mark Lord <lkml@rtr.ca>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, rubini@vision.unipv.it,
       linux-input@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: REGRESSION: 2.6.24:  false double-clicks from USB mouse
In-Reply-To: <4757B288.7060907@otello.alma.unibo.it>
Message-ID: <Pine.LNX.4.64.0712061320280.20118@jikos.suse.cz>
References: <4752DB8C.50608@rtr.ca> <4752E432.10504@rtr.ca> <4752E5AD.40905@rtr.ca>
 <4752F226.1090003@garzik.org> <Pine.LNX.4.64.0712021907490.13260@jikos.suse.cz>
 <4757B288.7060907@otello.alma.unibo.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2007, Diego Zuccato wrote:

> It happens to me, too. Wireless mouse, gives some "wheel up" signals 
> when going into powersave state. Kernel is 2.6.22-tmb-laptop-2mdv 
> (Mandriva Cooker).

Is this a regression for you? Are you able to say which kernel first 
exposed this behavior in your case?

> Maybe a more-or-less undocumented sequence to tell the host it's going 
> to sleep?

usbmon and/or HID_DEBUG output would be interesting to see (how to produce 
HID debugging output has been explained earlier in this thread, for usbmon 
please look in Documentation/usb/usbmon.txt).

Thanks,

-- 
Jiri Kosina
SUSE Labs
