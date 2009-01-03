Return-Path: <linux-kernel-owner+w=401wt.eu-S932264AbZACCdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbZACCdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 21:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758643AbZACCdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 21:33:14 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:23569 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559AbZACCdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 21:33:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=shNKNUJQ+9zlOcYK33yTkUPSaBgbqo88JQrzvBKXb04/mcjC87BP+lesLGyP5HrZJc
         0HGKIc80p/PvWMBVwL8T6rKkkts6CUOpXSnBHYNj5C6czFA7QSr0fxz3ZMqnvTiZshx0
         OEMZqvAUtJ8qwXeWELBe0dY/LGKW4R1HmWEvs=
Date: Sat, 3 Jan 2009 10:33:08 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Enable CONFIG_USB_SUSPEND by default or some mobile HD can't
	be unplugged safely
Message-ID: <20090103023308.GB6778@thyme.bj.intel.com>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090102140023.GC4833@thyme.bj.intel.com> <Pine.LNX.4.44L0.0901021056120.26494-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0901021056120.26494-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 11:04:40AM -0500, Alan Stern wrote:
> > Now I know 3 methods supposed can be used to shut the device:
> > 1. (Alan Stern said Windows use this) cut the USB port's power
> 
> I said no such thing!  In fact, I said exactly the opposite: Windows 
> does _not_ cut the port's power.  Instead it disables the port.

Sorry, my mistake.

> The best approach is to send a SYNCHRONIZE CACHE command followed by 
> START-STOP (if the device supports it), and then to disable or suspend 
> the port.  In Linux, those two commands will be sent automatically if 
> you unbind the device from usb-storage.  The suspend has to be done 
> manually unless you have set up a udev rule (or something equivalent) 
> to enable autosuspend for the device.  Of course, this requires 
> CONFIG_USB_SUSPEND.

Quite clear, thanks. 

-- 
Li, Yan
