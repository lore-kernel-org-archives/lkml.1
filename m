Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbYHISOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbYHISOV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 14:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbYHISOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 14:14:09 -0400
Received: from tihlde.org ([158.38.48.10]:37432 "EHLO tihlde.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbYHISOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 14:14:08 -0400
X-Greylist: delayed 1971 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Aug 2008 14:14:08 EDT
Message-ID: <489DD6BF.5030403@mrfjo.org>
Date: Sat, 09 Aug 2008 19:41:19 +0200
From: =?ISO-8859-1?Q?Espen_Fjellv=E6r_Olsen?= <espen@mrfjo.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: 158.38.48.18
X-SA-Exim-Mail-From: espen@mrfjo.org
Subject: megaraid_mm not showing up in 2.6.25.2
X-SA-Exim-Version: 4.2.1 (built Fri, 20 Jun 2008 19:33:36 +0200)
X-SA-Exim-Scanned: Yes (on tihlde.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
We are experiencing that megaraid_mm wont register on a 2.6.25.2 on our 
production server.
The module are compiled into the kernel, but /dev/megamon0 is not 
created, and we dont find any signs in eg. /proc/devices so a manual 
mknod would seem not to work.

We didnt experience this problem on 2.6.24.2 which were our previous kernel.

02:03.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID (rev 01)
    Subsystem: Dell MegaRAID 518 DELL PERC 4/DC RAID Controller
    Flags: bus master, 66MHz, slow devsel, latency 64, IRQ 27
    Memory at ff5f0000 (32-bit, prefetchable) [size=64K]
    Expansion ROM at fc8f0000 [disabled] [size=64K]
    Capabilities: [80] Power Management version 2

 From kernel log:
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megaraid: probe new device 0x1000:0x1960:0x1028:0x0518: bus 2:slot 3:func 0
megaraid: fw version:[352B] bios version:[1.10]

--
Best Regards
Espen Fjellvær Olsen
Drift@tihlde
