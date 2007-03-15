Return-Path: <linux-kernel-owner+w=401wt.eu-S1751468AbXCOKQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbXCOKQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 06:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbXCOKQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 06:16:55 -0400
Received: from mx1.ciphirelabs.net ([217.72.114.64]:34462 "EHLO
	mx1.ciphirelabs.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbXCOKQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 06:16:54 -0400
X-Greylist: delayed 1310 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Mar 2007 06:16:54 EDT
From: Andreas Jellinghaus <aj@leogic.com>
To: Con Kolivas <kernel@kolivas.org>
Subject: rsdl 30 on 2.6.20.2 breaks user space usb
Date: Thu, 15 Mar 2007 10:54:29 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703151054.29591.aj@leogic.com>
X-Ciphire-Security: plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

with plain 2.6.20.2 I get events / called from udev for /proc/bus/usb devices.
with rsdl 0.30 added to the kernel I no longer get called for those devices
(but I do get called for the new /dev/usbdev devices - except that I can't use 
them).

any idea why and what to do? might be related to a race condition.

I can also provide kernel config, dmesg, etc. whatever.
system is x86 with ubuntu edgy installed. I noticed the problem
with openct - the udev helper doesn't get spawned with the rsdl
kernel, while it does get spawned with the normal kernel.

Regards, Andreas
