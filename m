Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343Ab0BYPaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:30:10 -0500
Received: from legolas.restena.lu ([158.64.1.34]:57414 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759013Ab0BYPaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:30:07 -0500
Date: Thu, 25 Feb 2010 16:29:32 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>
Subject: Re: [PATCH 1/3] picolcd: driver for PicoLCD HID device
Message-ID: <20100225162932.43ee42a8@neptune.home>
In-Reply-To: <alpine.LNX.2.00.1002251615570.30967@pobox.suse.cz>
References: <20100221002001.0a7e05a7@neptune.home>
	<20100224170049.0d04af3c@neptune.home>
	<alpine.LNX.2.00.1002251201430.30967@pobox.suse.cz>
	<20100225123214.0523a310@neptune.home>
	<alpine.LNX.2.00.1002251615570.30967@pobox.suse.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 February 2010 Jiri Kosina <jkosina@suse.cz> wrote:
>
> On Thu, 25 Feb 2010, Bruno Prémont wrote:
> 
> > For the two sysfs attributes I currently use, the 'reset' one shall 
> > probably be moved to debugfs (I would like to place it under 
> > /sys/kernel/debug/hid/$device/ next to rdesc and event).
> 
> Yes, that would make sense.

So I will move it.

> ( ... which reminds me to finally to the Documentation/ABI part in
> sync with respect to current HID code again ... )
> 
> > By the way, I'm wondering why event does not list any of the
> > reports coming from my device though as I understand the code it
> > should be doing that before my raw_event function gets called...
> 
> Sorry, what 'event' do you mean in 'event does not list any of the 
> reports'?

Sorry, one 's' that got eaten between my brain and mail client. I
mean events file in debugfs.
For USB HID keyboard each key press generates "report dump" under
/sys/kernel/debug/hid/$device/events but for my PicoLCD I don't get
any entry in there. I'm wondering why.

Thanks,
Bruno
