Return-Path: <linux-kernel-owner+w=401wt.eu-S932227AbYGUDkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbYGUDkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 23:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759610AbYGUDkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 23:40:09 -0400
Received: from tihlde.org ([158.38.48.10]:43165 "EHLO colargol.tihlde.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758832AbYGUDkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 23:40:08 -0400
X-Greylist: delayed 1270 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jul 2008 23:40:08 EDT
Message-ID: <48840021.60001@tihlde.org>
Date: Mon, 21 Jul 2008 05:18:57 +0200
From: Roy Sindre Norangshol <norrs@tihlde.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 84.48.62.25
X-SA-Exim-Mail-From: norrs@tihlde.org
Subject: BUG: unable to handle kernel NULL pointer dereference - 2.6.25.7
X-SA-Exim-Version: 4.2.1 (built Fri, 20 Jun 2008 19:33:36 +0200)
X-SA-Exim-Scanned: Yes (on colargol.tihlde.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Last week I currently found our new server not responding to any of it's 
services,
so I went to data center to check on the server. I figured out that the 
logs had a line printing out that
this was a kernel bug (kernel.log) [1].

I tried upgrading to 2.6.26 release - but server died again on saturday, 
so going to check
logs later today (Monday) to see if it's another kernel bug popping up.

I scp'ed the logs [2] over to one of my other servers so you guys can 
see if there's anything useful there.

The system also runs on raid1 with mdadm and if I dont remember right, 
the hardware should be
an Intel Core2 Quad (Q6600) @ 2.4 GHz, 4GB of memory and motherboard of 
type P35 chipset,
motherboard P35C-DS3 [3] (I think) by Gigabyte. System is running Debian 
Stable with some packages
from backports, and compiled kernel myself from sources fetched from 
ftp.uio.no.

I'll provide more hardware information when I reboot the server, so I 
can run lspci, lshw, dpkg -l to provide
you guys with more information as I guess that would be nice. Anything 
else I should run?

NB: This is my first time posting to the list, and as far I understand, 
there is no need to run
the oops thru ksymoops since I'm running 2.6 branch of the kernel. 
Anyway, I'll gladly try to
send more details - just tell me what todo and I'll give it a try.

NB2: I'll probably fall back to standard Debian kernel (2.6.18 I think) 
(build from sources with my config) until I know what's causing this.

[1] http://www.norrs.no/kroton/kern.kroton
[2] http://www.norrs.no/kroton/
[3] 
http://tw.giga-byte.com/Support/Motherboard/BIOS_Model.aspx?ProductID=2633

--
Roy Sindre Norangshol


