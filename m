Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbYKAOwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbYKAOwj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 10:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbYKAOw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 10:52:29 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:12688 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYKAOw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 10:52:28 -0400
Message-ID: <ac3eb2510811010752o15853941m8a5497c927ba8479@mail.gmail.com>
Date: Sat, 1 Nov 2008 15:52:26 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Adam Nielsen" <a.nielsen@shikadi.net>
Subject: Re: Can you use the USB HID interface within a driver?
Cc: "Oliver Neukum" <oliver@neukum.org>,
       "LKML Mailinglist" <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
In-Reply-To: <490C4C59.7070003@shikadi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <490C4133.30400@shikadi.net> <200811011308.41339.oliver@neukum.org>
	 <490C4C59.7070003@shikadi.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 1, 2008 at 13:32, Adam Nielsen <a.nielsen@shikadi.net> wrote:
>>> Or perhaps someone could point me in the direction of a USB HID driver
>>> that does things "properly" already?
>>
>> Please post "lsusb -v" for your device.
>
> Here's the output.  I don't think any of the "class" drivers are suitable,
> except as templates for interfacing with the main HID code...I think...

I think, a real in-kernel driver for HID Power devices, which exports
the device as a "power_supply" device to userspace, would be nice.

That way, USB UPS's which support the HID Power devices:
  http://www.usb.org/developers/devclass_docs/pdcv10.pdf

would show up like any other battery and AC connector and userspace
could handle all of them without any specialized code:
  ls -1 /sys/class/power_supply/BAT0/
  alarm
  energy_full
  energy_full_design
  energy_now
  manufacturer
  model_name
  power
  present
  serial_number
  status
  technology
  type
  voltage_min_design
  voltage_now
  ...

Thanks,
Kay
