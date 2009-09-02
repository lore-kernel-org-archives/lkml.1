Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbZIBVZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbZIBVZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 17:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbZIBVZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 17:25:49 -0400
Received: from mail.cs.nmsu.edu ([128.123.64.3]:42040 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbZIBVZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 17:25:48 -0400
Message-ID: <a571ebde1bc221dd250a03e9fb33ed66.squirrel@intranet.cs.nmsu.edu>
Date: Wed, 2 Sep 2009 15:25:50 -0600
Subject: Problem starting the input interrupt pipe on the G13
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Linux USB" <linux-usb@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm still working on the G13 driver, but I've run into a problem with the
interrupt in pipe. In essence, I can't figure out how to get it started.

The driver can be found at:
http://g13.svn.sourceforge.net/viewvc/g13/driver/trunk/

I think the root of the problem lies in the fact that the G13 usage page
is 0x00 (undefined). The output and feature reports seem to be working
fine to set the backlight color, the LCD image and the leds on the 'M'
keys.

However, nothing seems to be happening with the input report (there is
only one input report type on endpoint address 0x81 that contains the
joystick and key values).

The problem is getting the input pipe started. I grepped through the other
drivers in the hid directory and I couldn't find any that had to
explicitly start the input interrupt.

Any suggestions?

Thanks,

Rick


