Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbZBSLRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbZBSLRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbZBSLRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:17:10 -0500
Received: from [62.67.244.94] ([62.67.244.94]:39626 "EHLO
	s8073.evanzo-server.de" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753714AbZBSLRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:17:09 -0500
To: linux-kernel@vger.kernel.org
Subject: No Scancodes for "Logitech NuLOOQ"
Content-Disposition: inline
From: Tobias Kaminsky <mail@finswimmer.de>
Date: Thu, 19 Feb 2009 12:16:23 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200902191216.24045.mail@finswimmer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am trying to get the "Logitech NuLOOQ" USB jog/shuttle to work.
Here is a picture of it to see its capabilities:
http://technabob.com/blog/wp-content/uploads/2006/10/logitech_nulooq.jpg

getscancode gives me:

$./getscancodes /dev/input/event3
Input driver version is 1.0.0
Input device ID: bus 0x3 vendor 0x46d product 0xc640 version 0x110
Input device name: "3Dconnexion NuLOOQ Navigator"
589827 (0x90003)
589827 (0x90003)
589825 (0x90001)
589825 (0x90001)
589825 (0x90001)
589828 (0x90004)
589825 (0x90001)
589828 (0x90004)
589826 (0x90002)
589826 (0x90002)
589829 (0x90005)
589829 (0x90005) Button "II"

This represents the five buttons on top of it.
But the NuLOOQ has a "navring" which you can turn left/right.
This does not generates a scancode.

evbug gives me:
 Connected device: input3 (3Dconnexion NuLOOQ Navigator at 
usb-0000:00:02.0-2/input0)

Button "II" is represented like this:
 Event. Dev: input3, Type: 4, Code: 4, Value: 589829
 Event. Dev: input3, Type: 1, Code: 260, Value: 1
 Event. Dev: input3, Type: 0, Code: 0, Value: 0
 Event. Dev: input3, Type: 4, Code: 4, Value: 589829
 Event. Dev: input3, Type: 1, Code: 260, Value: 0
 Event. Dev: input3, Type: 0, Code: 0, Value: 0

For this one it seems as if the "value" is the scancode.

Turning the "navring" to the right results in:

 Event. Dev: input3, Type: 2, Code: 1, Value: 125
 Event. Dev: input3, Type: 2, Code: 5, Value: -148
 Event. Dev: input3, Type: 0, Code: 0, Value: 0
 Event. Dev: input3, Type: 2, Code: 0, Value: 71
 Event. Dev: input3, Type: 2, Code: 1, Value: 79
 Event. Dev: input3, Type: 2, Code: 5, Value: -86
 Event. Dev: input3, Type: 0, Code: 0, Value: 0
 Event. Dev: input3, Type: 2, Code: 0, Value: 71
 Event. Dev: input3, Type: 2, Code: 1, Value: 39
 Event. Dev: input3, Type: 2, Code: 5, Value: -56
 Event. Dev: input3, Type: 0, Code: 0, Value: 0
 Event. Dev: input3, Type: 2, Code: 0, Value: 32
 Event. Dev: input3, Type: 2, Code: 1, Value: 21
 Event. Dev: input3, Type: 2, Code: 5, Value: -23
 Event. Dev: input3, Type: 0, Code: 0, Value: 0
 Event. Dev: input3, Type: 2, Code: 0, Value: 10
 Event. Dev: input3, Type: 2, Code: 1, Value: 9
 Event. Dev: input3, Type: 2, Code: 5, Value: -3
 Event. Dev: input3, Type: 0, Code: 0, Value: 0


How can I verify these scancodes and get them into the kernel?

I have searched the web, but not found a howto/tutorial on getting/creating 
new scancodes.

Thanks in advance!

Tobias Kaminsky


