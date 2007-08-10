Return-Path: <linux-kernel-owner+w=401wt.eu-S935698AbXHJMde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935698AbXHJMde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 08:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbXHJMd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 08:33:27 -0400
Received: from wasp.net.au ([203.190.192.17]:48154 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588AbXHJMd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 08:33:26 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Aug 2007 08:33:26 EDT
Message-ID: <46BC59E3.2010402@wasp.net.au>
Date: Fri, 10 Aug 2007 16:28:19 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Advice on a userspace tty serial driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

G'day all,

I'm building a bit of hardware. It's basically a serial multiplexer that communicates to the PC 
using a single usb-serial port. It has the ability to run between 2 and 8 standard async ports over 
this single interface.

I'd rather not write a kernel driverif possible as I figure this would be a perfect application for 
a userspace daemon to do the control and mux/demux. I'd prefer to present standard serial style 
devices (/dev/ttySxx) to userspace giving me the ability to run unmodified software to talk to the 
multiplexed ports.

I think tty/pty pairs looks roughly what I'm after, but will they allow me to use standard IOCTLS 
for conveying baud rate and other standard serial parameters to the daemon?

I've spotted several userspace serial driver projects in the last 7 or so years, but I can't seem to 
find any that made it into the kernel.

Am I on the right track with tty/pty or is there a better way?

Regards,
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
