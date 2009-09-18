Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbZIRJgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbZIRJgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 05:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbZIRJgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 05:36:36 -0400
Received: from web50204.mail.re2.yahoo.com ([206.190.38.45]:42864 "HELO
	web50204.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756131AbZIRJge convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 05:36:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=xB6Lmk76tq315o5xXDCQCvuEHmGdZEBT4zHUtBzorIKNCvhGqOYXZuioCPpLsphV7xrk4whzJ7a0iuKCZaqfUiVdfHm8VXhTEJFKRMdAX6uUjSh8gKDNIcIpNMOuDS7U2LydN2hCc4AruEPbb1y77LsUlpU1BRR/ycBSVHMox4A=;
Message-ID: <778490.95843.qm@web50204.mail.re2.yahoo.com>
X-YMail-OSG: gdUkBOQVM1lWiZv6bZNj63V0LDPWWBdJS3JTdE1_IY2rypRtVfQhHtC9nOHTL_EyGkUN1PPG5BZJ03wIJeaJeEVq4UJ74J8_.Lae4t5MxfUwu4C7jpTB0V5mhWBiKX1MFkRXeozGsRDBASMA3DJzB5ywG4deo2khrkU4vvW.ytphRLKpeGayOlD2aw39N_5FwGa0kRtWE2u38c1onJIeyc6RnNE2SQx8.TieiaPf.VIbz2wwikbB.vFkStuFRF5arnVwjZZsEM9gAwTZeYHIhtxh3A--
X-Mailer: YahooMailClassic/7.0.14 YahooMailWebService/0.7.347.2
Date: Fri, 18 Sep 2009 02:36:37 -0700 (PDT)
From: vprabu vprabu <prabu_online2005@yahoo.com>
Subject: Auto loading of kernel modules COLD/HOT BOOT
To: linux-hotplug@vger.kernel.org
Cc: linux-pci@vger.kernel.org, linux-usb@vger.kernel.org,
       kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This is prabu .

I am new to kernel hacking ; i had been an application guy; now focusing into the fundamentals of linux kernel. I really have little knowledge about the kernel, modules and auto loading of modules.After a lot of googling ,i am now much perplexed :-)  Most of the articles are contradictory to each other and not very clear ( or not so simple at my level to comprehend)

1. How does a linux distribution know which feature is to be set in kernel and which one as a module.

2. Now after installation, i reboot the server ....( COLDPLUG )

*. Does the hardware probing is done first and then the relevant drivers are loaded for the hardware found. If so how is this achieved.

( or )

*. Else if the hardware driver is loaded FIRST from modprobe.conf and does it go in search of a corresponding device supported by the driver?

ie. Need to know a device is found first and its corresponding driver is loaded or the driver is loaded first which brings up the device

3. HOTPLUG ......


*. I now add a new network card to the PCI slot. ( 2.6 )

*. I assume that the PCI controller sends a signal to the kernel that a new device is added

*. The new device's firmware details like vendor id, prod id is propogated to /sys file system.

*. udevd tries to load the device drivers containing that particular vendor id in /lib/modules/kernel.xx/net

i have a doubt ... like.. does it search only /etc/modprobe.conf or all the modules under /lib/modules.

 
4. How does the same hotplug and cold plug happen in case of 2.4 kernels.

where does kmod , kerneld come into picture

5.  What is the main role of rc.sysinit -- does this handle device and drivers.

6. Dont know when to put an entry in modprobe.conf and when not to.

7. why does lsmod show something different from modprobe -c

8. How does modprobe -c get those values. why does it vary with lsmod output

9. There are two SCSI hostadapters of same type. Do i need  to load the module twice for it or once?

In simple words how a device driver is loaded at boot/hotplug for 2.4 and 2.6 kernels


I know each one is inter-related but dont know how they are?. I cant find any good article to explain the 

working of modules in simple words (both 2.4 / 2.6 with examples)

Any help in this regard is much appreciated....

Prabu


      
