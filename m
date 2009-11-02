Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbZKBQ7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbZKBQ7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbZKBQ7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:59:42 -0500
Received: from mail.ihtiyat.org ([212.108.130.11]:2480 "EHLO ebim.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756255AbZKBQ7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:59:41 -0500
X-Greylist: delayed 1823 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Nov 2009 11:59:40 EST
Subject: Faulty MTRR setups in Toshiba laptops crash video drivers
From: Mehmet Giritli <mehmet@giritli.eu>
Reply-To: mehmet@giritli.eu
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 02 Nov 2009 18:28:48 +0200
Message-Id: <1257179328.13327.34.camel@frodo.giritli.eu>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On some laptops using ATI 3650HD radeon chipsets and 4GB ram (and may be
others as well), it is impossible to start any xserver due to (faulty?)
mtrr setups on the machine. The computer locks up or just gives an
unresponsive black screen. There are various drivers for radeon cards
and the crash occurs in all of these drivers in the very same way!

This bug seems to occur mostly on Toshiba laptops with ATI graphic
cards. For some people, CONFIG_MTRR_SANITIZER seemed to cure the issue
but made no difference for many others like me.

RadeonHD people seem to have problems in understanding the nature of
this bug. Please have a look at the threads:

http://lists.opensuse.org/radeonhd/2009-05/msg00040.html

and, 

http://bugs.freedesktop.org/show_bug.cgi?id=20645

for problem reports and dev responses. RadeonHD devs suggest that some
laptops have weird mtrr setups and this must be fixed in the kernel code
and not the driver code.

Currently, the only way that could make the driver work is to reduce the
4GB ram to 2GB.

dmesg from my affected machine when it has 4GB ram installed can be
found here:

http://bugzilla.kernel.org/attachment.cgi?id=22856

Also, look at the report here:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/341681

in order to see how many people are being affected by this bug!

Kind Regards,
M. Giritli


