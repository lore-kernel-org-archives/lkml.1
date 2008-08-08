Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbYHIG3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbYHIG3T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 02:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYHIG3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 02:29:08 -0400
Received: from esbens.latnet.lv ([92.240.66.74]:59209 "EHLO esbens.latnet.lv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbYHIG3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 02:29:07 -0400
X-Greylist: delayed 1589 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Aug 2008 02:29:07 EDT
From: Aivils Stoss <aivils@latnet.lv>
To: linux-input@vger.kernel.org, jkosina@suse.cz, linux-kernel@vger.kernel.org,
       linuxconsole-dev@lists.sourceforge.net
Subject: PROBLEM: USB keyboards works only 4 per PC host port
Date: Fri, 8 Aug 2008 07:02:24 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808080702.24969.aivils@latnet.lv>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All!

PROBLEM: USB keyboards works only 4 per PC host port.

I work for project which will use 15 - 25 keyboards for children teaching.
I discover current Linux 2.6.22 , 2.6.24, 2.6.26 dot not support more
than 4 keyboards per single PC host port. All plugged in keyboards
are listed as USB devices, listed as input devices, but capable to
send input events are only 4 keyboards, no matter where keyboards
are plugged in to HUB cascade. All plugged in keyboards switch LED's,
when i press NumLock.

I tested various usb-hub units and various host PC hardware, i even
replace hub power supplay units from 5V1A to 5V3A. All tested cases
give best results - 4 keyboards per PC host port and worstest - some PC
cannot do more than 8 keyboards at all.
I suppose this is Linux kernel bug because i test keyboards under
Windows, which support any schema of cascading of usb hubs.

I will send any log file if that is necessary, but trouble will pop up
in a row of kernels. 2.6.22 didn't have error messages. 2.6.24, 2.6.26
tend to total slow down with eternal reset messages:
Jul 25 07:16:00 awork kernel: input,hiddev97: USB HID v1.10 Mouse 
[USB-compliant keyboard] on usb-0000:00:1d.0-1.1.2
Jul 25 07:16:01 awork kernel: usb 2-1.1.1: reset low speed USB device using 
uhci_hcd and address 17
Jul 25 07:16:01 awork kernel: usb 2-1.1.2: reset low speed USB device using 
uhci_hcd and address 18
Jul 25 07:16:02 awork kernel: usb 2-1.1.1: reset low speed USB device using 
uhci_hcd and address 17


Best regards,
Aivils Stoss
