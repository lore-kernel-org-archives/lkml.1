Return-Path: <linux-kernel-owner+w=401wt.eu-S1762553AbZAHV0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762553AbZAHV0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 16:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZAHV0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 16:26:04 -0500
Received: from smtpoutwbe08.prod.mesa1.secureserver.net ([208.109.78.210]:60116
	"HELO smtpoutwbe08.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762823AbZAHV0B convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 16:26:01 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2009 16:26:01 EST
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Originating-IP: 199.64.0.252
User-Agent: Web-Based Email 4.14.17
Message-Id: <20090108141921.5c1bb9f86d671edec44bb378f25c04cc.a190016ce1.wbe@email.secureserver.net>
From: duane@duaneellis.com
To: linux-kernel@vger.kernel.org
Subject: kernel 2.4.37 usb acm hard lockup
Date: Thu, 08 Jan 2009 14:19:21 -0700
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I have a linux-2.4.37 - kernel *HANG* hard lockup that I am
trying to debug, ctl-alt-del does not fix the problem. The problem does
not occur on current 2.6 kernels.

Specifically the device I am talking to is an USB-ACM type 'scanner'
type device, it shows up as a USB com port /dev/input/ttyACM0 - and I
read/write commands to & from the device.

Some fixes have already been back ported from 2.6 (trying to get it to
run on 2.4.20-8 [rh9]) and I'm not getting far and asking for some help
or some pointers where to go next.

The bug is quite reproducible - I have a small C program, and a small
shell script loop. It sends a few commands (ie: initialize, scan and
transmit image) then saves the image to a file.  Somewhere between 70 to
150 scans BANG a hard hang occurs, takes between 5 to 15 minutes.

I get *NO* output on the console, like an oops or something like that.
Only debug messages I have added in my program.

I have already turned the USB KERNEL debug messages on in the .config
file, and I have "dmesg -n 9".

And - if I do add too many of my own debug messages, depending on the
volume of messages the problem takes longer to appear or goes away (I
give up after several hours) - which makes me think it is a timing/race
condition :-(

If this is the wrong list, or there is a better list for this specific
2.4/usb/acm problem please let me know, I don't really know where else
to ask.

Thanks.

-Duane.







