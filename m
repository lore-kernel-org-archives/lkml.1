Return-Path: <linux-kernel-owner+w=401wt.eu-S965263AbXDBJjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965263AbXDBJjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 05:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965310AbXDBJjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 05:39:49 -0400
Received: from styx.suse.cz ([82.119.242.94]:51833 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965263AbXDBJjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 05:39:48 -0400
Date: Mon, 2 Apr 2007 11:34:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Li Yu <raise.sail@gmail.com>
Cc: Dmitry Torokhov <dtor@insightbb.com>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
In-Reply-To: <4610ABB1.3080606@gmail.com>
Message-ID: <Pine.LNX.4.64.0704021126280.3808@jikos.suse.cz>
References: <200703051532096508636@gmail.com> <Pine.LNX.4.64.0704010002280.6040@jikos.suse.cz>
 <4610609C.9030101@gmail.com> <200704020015.44167.dtor@insightbb.com>
 <4610ABB1.3080606@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, Li Yu wrote:

> Hi, I do not think that using blacklist in base driver for this purpose 
> is good idea. If so, we need modify source when each new HID device 
> driver come, that's so ugly. 

Hi Li,

well, the drivers are exceptions from the generic handling, so creating an 
exceptional rule (entry in hid_blacklist) for them is not that bad. OK, 
it's not the nicest thing on earth probably, but serves the purpose in 
current vendors-trying-to-break-hardware-in-the-most-original-way world 
quite well.

This is going to cause some headache to out-of-tree drivers. Oh well, do 
we care that much? 

In your scenario you'll still need a way how to unbind the device from the 
hid driver and bind it to the new specific device, won't you?. This could 
be done by a separate userspace program, but well ... I think just 
blacklisting the hardware is much cleaner, than needing to ship a separate 
userspace program along with the driver.

Thanks,

-- 
Jiri Kosina
