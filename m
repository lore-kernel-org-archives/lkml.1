Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbXCERoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbXCERoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 12:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXCERoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 12:44:38 -0500
Received: from max.feld.cvut.cz ([147.32.192.36]:57238 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbXCERoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 12:44:37 -0500
From: CIJOML <cijoml@volny.cz>
To: linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org
Subject: Marco's Opera driver fails load firmware
Date: Mon, 5 Mar 2007 18:44:15 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703051844.15981.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marco,

I just tested your driver you have posted to the linux-dvb mailing list.
I have problem load firmware into device:

usb 5-3: new high speed USB device using ehci_hcd and address 4
usb 5-3: configuration #1 chosen from 1 choice
dvb-usb: found a 'Opera1 DVB-S USB2.0' in cold state, will try to load a 
firmware
dvb-usb: downloading firmware from file 'opera1.fw'
dvb-usb: firmware download failed at 9418 with -22
opera1: probe of 5-3:1.0 failed with error -22
usbcore: registered new interface driver opera1

My firmware files are:

-rw-r--r-- 1 root root  8300 2006-04-05 21:23 opera1-2.fw
-rw-r--r-- 1 root root 55894 2006-04-05 21:23 opera1-fpga.fw
-rw-r--r-- 1 root root  9432 2006-04-05 21:22 opera1.fw

60aa3e8a540de75d0f456d3979408d7d  /usr/lib/hotplug/firmware/opera1-2.fw
2b48b0923de2fdfcb160d9cce3d3529d  /usr/lib/hotplug/firmware/opera1-fpga.fw
95032d7201b25e0f8ee802c5b292aa69  /usr/lib/hotplug/firmware/opera1.fw

I have created wish in kernel's bugzilla before, so we can track it there:

http://bugzilla.kernel.org/show_bug.cgi?id=7574

Thanks for help.

Michal
