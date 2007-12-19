Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbXLSXfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbXLSXfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 18:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbXLSXfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 18:35:04 -0500
Received: from nofear-snat.bivio.net ([216.142.75.231]:33254 "EHLO
	corpexc01.corp.networkrobots.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757516AbXLSXe7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 18:34:59 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: printf internals
Date: Wed, 19 Dec 2007 15:31:15 -0800
Message-ID: <D83235F0F3C86D4D889D8B9A0DA8C6D7012AF56B@corpexc01.corp.networkrobots.com>
In-Reply-To: <1198107085.7740.0.camel@oasis.donpoo.home>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: printf internals
Thread-Index: AchClsMdyDxsjMeDSYSFTMXDdvaWMQAAD4BA
References: <D83235F0F3C86D4D889D8B9A0DA8C6D7011A8217@corpexc01.corp.networkrobots.com> <4761E289.9070007@davidnewall.com> <4762AC35.3010706@anagramm.de> <D83235F0F3C86D4D889D8B9A0DA8C6D7012AF540@corpexc01.corp.networkrobots.com> <1198107085.7740.0.camel@oasis.donpoo.home>
From: "Siva Prasad" <sprasad@bivio.net>
To: "Scott Russell" <catfather@donpoo.net>
Cc: "Clemens Koller" <clemens.koller@anagramm.de>,
       "David Newall" <david@davidnewall.com>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Yes!... this is a embedded system, and will not have monitor. So, serial
is the default console.

I pass cmdline as "root=/dev/ram rw console=ttyS0,115200"

Thanks
Siva


-----Original Message-----
From: Scott Russell [mailto:catfather@donpoo.net] 
Sent: Wednesday, December 19, 2007 3:31 PM
To: Siva Prasad
Cc: Clemens Koller; David Newall; linux-kernel@vger.kernel.org
Subject: RE: printf internals


On Wed, 2007-12-19 at 14:33 -0800, Siva Prasad wrote:
> Thank you very much for your response Clemens.
> 
> I tried strace on a regular system. It does not show which tty, etc.,
as it uses the stdout (fd = 1) and write(1, ...) to it.
> 
> This is not a student project. I am trying to build my own kernel and
ramdisk. Kernel boots fine to a point where it starts accessing ramdisk
and executes init scripts. From there on nothing gets printed. I did
some debugging and found that prints of user land programs are not
coming to the serial console, while kernel prints are working fine. I
found all the programs getting executed, by placing a printk in execve
routine and printing the arguments.
> 
> So, I wanted to trace down the path from user program to the kernel
and see why it is not printing messages from user program. I placed a
printk in drivers/char/tty_io.c:tty_write() and it is not getting called
from my file system. I tried the same thing on my good system (say
regular PC) and it works as expected.
> 
> Any clues that can help debug this issue is highly appreciated.
> How can I get access to the same printf string inside kernel.

This sounds like you're printing out the serial console instead.

-- 
Scott <catfather@donpoo.net>
AIM: BlueCame1

