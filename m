Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbXGPSte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbXGPSte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbXGPSt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:49:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49804 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbXGPSt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:49:27 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <469BBDAD.2010908@s5r6.in-berlin.de>
Date: Mon, 16 Jul 2007 20:49:17 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: 2.6.22-git* regression: Kconfig prompts without help text
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It is an error to add visible Kconfig options without help text.  Among
them are the new "menuconfig" options.  Jan obviously never uses "make
oldconfig".  Most of these options were added after 2.6.22:

BLK_DEV
HID_SUPPORT
INSTRUMENTATION
MACINTOSH_DRIVERS
MISC_DEVICES
USB_SUPPORT

Here are suggestions for help texts.  Please verify if they are correct
and check whether there are more new (menuconfig) options without help
texts.


BLK_DEV
Say Y here to get to see options for various different block device
drivers.  This option alone does not add code to the kernel.

If you say N, options will be skipped and disabled.  Hence say Y.


HID_SUPPORT
Say Y here to get to see options for various computer--human interface
device drivers.  This option alone does not add code to the kernel.

If you say N, options will be skipped and disabled.  Hence say Y.


INSTRUMENTATION
Say Y here to get to see options related to performance measurement,
debugging, and testing.  This option alone does not add code to the kernel.

If you say N, options will be skipped and disabled.


MACINTOSH_DRIVERS
Say Y here to get to see options for devices used with Macintosh
computers, both PPC and Intel based.  This option alone does not add
code to the kernel.

If you say N, options will be skipped and disabled.


MISC_DEVICES
Say Y here to get to see options for device drivers from various
different categories.  This option alone does not add code to the kernel.

If you say N, options will be skipped and disabled.  Hence say Y.


USB_SUPPORT
This option adds core support for Universal Serial Bus (USB).
You will also need drivers from the following menu to make use of it.


PS:

I believe one possible *bug* of this menuconfig stuff is that if (1.)
user X disables menuconfig A in linux-2.6.x because nothing interesting
for him is in there, (2.) developer Y adds something very interesting in
menu A in linux-2.6.x+1, --> (3.) user X will miss this new option when
he runs "make oldconfig" when switching to linux-2.6.x+1 because
everything between 'if A'...'endif # A' will be invisible and disabled.
-- 
Stefan Richter
-=====-=-=== -=== =----
http://arcgraph.de/sr/
