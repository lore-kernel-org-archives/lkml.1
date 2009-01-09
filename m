Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbZAIKM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbZAIKM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbZAIKMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:12:49 -0500
Received: from mx.hosting-seguridad.com ([88.198.93.158]:52931 "EHLO
	mx.hosting-seguridad.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbZAIKMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:12:48 -0500
X-Greylist: delayed 1954 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jan 2009 05:12:47 EST
X-Spam-Score: -2.282
Message-ID: <49671B77.7080705@rs-labs.com>
Date: Fri, 09 Jan 2009 10:40:07 +0100
From: Roman Medina-Heigl Hernandez <roman@rs-labs.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Oops with Gigabyte motherboard "GA-X48-DQ6" and r8168 Realtek driver
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello kernel-hackers,

I bought a PC intended to be used as a server with the recent Gigabyte
motherboard "GA-X48-DQ6":
http://www.giga-byte.es/products/mb/specs/ga_x48_dq6.html

It includes two RTL8111/8168B NICs, which seem the cause of the kernel
crashes (*but I'm not sure*)..., a Quad core, 4GB RAM and two 500GB HDs.

I installed Debian Linux (4.0) on it and I'm getting *kernel panic*
errors (r8168 module) when set to production state. I couldn't get any
kernel debug messages since I'm using Debian stock kernel
(2.6.18-6-686-bigmem) and I'm not a kernel hacker either. It happens from
time to time so it is not easily reproduceable, or at least I couldn't find
the way to reproduce it on purpose (I stressed the server forcing huge sftp
transfers and/or using iperf tool, without success). But the problem is
there and it seems a NIC driver problem.

Moreover, the machine is located at a remote location so I have to trust
other people reading screen messages for me, etc. It's not easy to debug in
this situation. I've been told that the oops were produced in r8168 module,
from time to time, and that they saw also one only crash while booting the
server "due to SATA" (???). The server uses software-raid and was
re-syncing to a second disk since the second disk was new (so expect high
disk load). I'm a bit confused, it seems that the problem could be the
r8168 driver but I cannot be sure at all.

Could you help me? Do you have reports of similar problems with similar NIC
/ motherboard? How to solve it? I'm sorry for not providing more info
(lspci, etc) but as I previously said the server is in a remote location
and it's currently powered-off. Any hints?

I'm using latest Realtek driver for RTL8111/8168B at:
ftp://202.65.194.212/cn/nic/r8168-8.010.00.tar.bz2
(I have r8169 driver *not* loaded and blacklisted in
/etc/modprobe.d/blacklist -since it didn't work for my 8111B-, and initrd
was rebuilt with new r8168 driver; so the only NIC driver loaded is r8168,
compiled from the former .tar.bz2 (8.010 version).

As a quick workaround (since I need to put that server on production state
*ASAP*), would you recommend to boot with safer options (noacpi, etc)?
Which ones exactly? (no problem if they degrade performance a bit or if
they cause less power-saving; in this case, stability and uptime is preferred).

Thank you from your comprehension and cooperation.
-Roman
