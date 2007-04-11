Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbXDKP5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbXDKP5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 11:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbXDKP5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 11:57:31 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:9664 "EHLO
	outbound2-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753169AbXDKP5a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 11:57:30 -0400
X-BigFish: VP
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: kernel space to user space /bin/sh startup
Date: Wed, 11 Apr 2007 08:57:27 -0700
In-Reply-To: <Pine.LNX.4.61.0704111747140.32056@yvahk01.tjqt.qr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: kernel space to user space /bin/sh startup
Thread-Index: Acd8UM40aAySG9zBQiGgQYInpTn22QAANq+w
References: <20070410182240.3AFAF590046@mail41-cpk.bigfish.com> <Pine.LNX.4.61.0704111747140.32056@yvahk01.tjqt.qr>
From: "Tom Strader" <tom.strader@xilinx.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Apr 2007 15:57:28.0175 (UTC) FILETIME=[1AC6D7F0:01C77C52]
Message-Id: <20070411155728.E46EAE8054@mail197-blu.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nope.  Terminal is set correctly, the kernel is outputting messages, the
command line arguments sent to the kernel have 115200 set.  What would
happen if the getty was not started correctly?  Would the echoes in rcS
still appear?  I feel like it may be related to the getty and userspace
prints due to the fact the kernel is still printing and responding to
commands.
Tom

-----Original Message-----
From: Jan Engelhardt [mailto:jengelh@linux01.gwdg.de] 
Sent: Wednesday, April 11, 2007 8:48 AM
To: Tom Strader
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel space to user space /bin/sh startup


On Apr 10 2007 11:22, Tom Strader wrote:

>console::sysinit:/etc/init.d/rcS
>console::respawn:/sbin/getty -L 115200 /dev/ttyS0 vt100

>Now I can type on the console and characters are echoed back, pressing
>ctrl-c echoes: "uart_flush_buffer(0) called" so the code is still
>running, but I am not sure where I am or why I see no login prompt or
>shell command line.
>I never see the "mounting filesystems..." echoed to the screen, but the
>code does not stall and no errors are reported by the kernel.  Any help
>during the transition from init/main.c in kernel space to user space
>would be appreciated, so I could debug this further.
>I have looked around and have not seen a solution for my problem, most
>likely due to the fact that I am not entirely sure what the problem is.

Perhaps your terminal program is set to 9600 bps?



Jan
-- 


