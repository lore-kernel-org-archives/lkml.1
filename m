Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbYKAL6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbYKAL6Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 07:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbYKAL6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 07:58:01 -0400
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:3196 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYKAL6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 07:58:00 -0400
Message-ID: <490C4133.30400@shikadi.net>
Date: Sat, 01 Nov 2008 21:44:51 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.16) Gecko/20080727 Thunderbird/2.0.0.16 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Can you use the USB HID interface within a driver?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm about to start writing a driver for a Gigabyte Odin PC power supply. 
  This device has a USB connection which allows you to monitor 
temperature, voltages, current, etc.

Before I start coding the USB side of things, I'd just like some advice 
as to the best way of communicating with the device.

I would rather write the driver in kernel space (so that it "just works" 
and provides a hwmon interface without installing extra software), 
however the device already appears to the system as a USB HID device, 
and so gets claimed by the existing usbhid driver.

Is there any way to interface with the HID driver from within another 
driver?  Or will I have to claim the device first (or disconnect 
usbhid), and communicate with it myself?

I've tried to find some example code from a driver that already does 
this (such as a USB keyboard driver) but I'm having some trouble finding 
one!  The closest drivers I can find are all the ones in 
drivers/hid/usbhid, but they all seem to be "embedded" in hid-core.c. 
Does that mean I need to modify hid-core.c to call my driver?

Or perhaps someone could point me in the direction of a USB HID driver 
that does things "properly" already?

Many thanks,
Adam.
