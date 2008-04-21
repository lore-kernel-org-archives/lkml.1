Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbYDUJ0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbYDUJ0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 05:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbYDUJZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 05:25:52 -0400
Received: from twin.jikos.cz ([213.151.79.26]:42955 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930AbYDUJZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 05:25:51 -0400
Date: Mon, 21 Apr 2008 11:25:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Anssi Hannula <anssi.hannula@gmail.com>
cc: Jiri Slaby <jirislaby@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       mit-devel@lists.printk.net, linux-kernel@vger.kernel.org
Subject: Re: HID bus
In-Reply-To: <480B6C16.40806@gmail.com>
Message-ID: <Pine.LNX.4.64.0804211124060.19002@twin.jikos.cz>
References: <Pine.LNX.4.64.0804181333180.12972@jikos.suse.cz>
 <1208644696-29129-1-git-send-email-jirislaby@gmail.com> <480B6C16.40806@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2008, Anssi Hannula wrote:

> Why not just do something like
> 
> #define HID_DEVICE(vend, dev) \
> 	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | \
> 		       USB_DEVICE_ID_MATCH_INT_CLASS, \
> 	.idVendor = (vend), \
> 	.idProduct = (prod), \
> 	.bInterfaceClass = USB_INTERFACE_CLASS_HID
> (see linux/usb.h)
> 
> and use USB hotplugging?
> Or do we plan to match against something else as well, such as hid
> reports or something?

No, we plan to do matching based solely on VID/PID. The report-specific 
stuff is then handled between the specific driver and HID generic code.

Thanks,

-- 
Jiri Kosina
SUSE Labs

