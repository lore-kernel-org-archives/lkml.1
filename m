Return-Path: <linux-kernel-owner+w=401wt.eu-S1759066AbYHUNS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066AbYHUNS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757313AbYHUNSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:18:46 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:43471 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758800AbYHUNSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:18:45 -0400
Message-ID: <48AD6AF0.3050504@csr.com>
Date: Thu, 21 Aug 2008 14:17:36 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
CC: linux-usb <linux-usb@vger.kernel.org>, torvalds@linux-foundation.org
Subject: New subsystems: Ultra-Wideband radio, Wireless USB and WiMedia LLC
 Protocol
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Aug 2008 13:17:36.0502 (UTC) FILETIME=[47693160:01C90390]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm the maintainer of the Ultra-Wideband (UWB) radio, Certified Wireless
USB (WUSB) and WiMedia LLC Protocol (WLP) subsystems.  These are now in
a state were I consider them suitable for inclusion into the kernel.

UWB is a new high speed, short range radio technology (480 Mbit/s at 1
m, 53.3 Mbit/s at 10 m).  The specifications are freely available and
are managed by the WiMedia Alliance.   For more information see
http://www.wimedia.org/.

Various protocols run on top of the UWB radio: Certified Wireless USB
(WUSB); WiMedia LLC Protocol (WLP), for IP (etc) networks; and (in the
future) high speed Bluetooth.

The code is some 35,000 lines so I won't be posting it to this list but
you can view the patch set here:

http://www.davidvrabel.org.uk/~david/linux/uwb/

Or you can pull the changes from the uwb branch of

git://pear.davidvrabel.org.uk/git/uwb.git

(Please don't clone the entire tree from here as I have very limited
bandwidth.)

Or you can view the patches in the linux-usb archive here:

http://thread.gmane.org/gmane.linux.usb.general/8715

The vast majority of the code forms part of the new UWB, WUSB, and WLP
subsystem with no impact on the rest of the kernel.  It has all been
posted to the linux-usb list and has been reviewed there.

For a wider review, I will follow up with the 2 minor patches that add
some simple infrastructure.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
