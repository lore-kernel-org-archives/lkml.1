Return-Path: <linux-kernel-owner+w=401wt.eu-S933391AbZJGNI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391AbZJGNI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933236AbZJGNI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:08:29 -0400
Received: from static.67.85.46.78.clients.your-server.de ([78.46.85.67]:34021
	"EHLO directfb.biz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbZJGNI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:08:28 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Oct 2009 09:08:28 EDT
Message-ID: <4ACC917D.3090302@directfb.org>
Date: Wed, 07 Oct 2009 15:02:53 +0200
From: Niels Roest <niels@directfb.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: DirectFB "Fusion" module inclusion?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

This is to request some comments about our interest to have our "Fusion" 
kernel module included in the kernel.
I hope you will let me now if it is feasible, desirable, etcetera.

What is Fusion? Fusion is the low-level layer of DirectFB 
(www.directfb.org). DirectFB is basically a graphics library that offers 
hardware acceleration and multi-process cooperation on top of e.g. the 
frame buffer device.

What does Fusion offer? Fusion takes care of IPC by providing the 
following primitives: skirmishes (locks), calls (partially via a 
user-space library handling callback threads), properties and shared 
memory pools. The main two reasons for us to make a kernel module out of 
this is: crashing applications will not take down the "DirectFB" system, 
since resources are handled in the kernel; and debug 
information/deadlock status is shared via /proc/fusion.

Fusion documentation (fusion.pdf) can be found at 
http://git.directfb.org/?p=core/linux-fusion.git;a=tree;f=doc;
Fusion source files can be found at the same git location: 
http://git.directfb.org/?p=core/linux-fusion.git;a=tree

Fusion is implemented as a device driver with an ioctl interface. In our 
case, Fusion is used together with libfusion.so (LGPL), which abstracts 
the kernel ioctls away, among other things. DirectFB resides on top of 
libfusion.so.

We would probably rework Fusion significantly if needed - we want to 
have the benefit of having Fusion inside kernel mainline, and we hope 
that it is indeed interesting enough to consider, so let's hear it :)

Greets
Niels

-- 

.------------------------------------------.
| DirectFB - Hardware accelerated graphics |
| http://www.directfb.org/                 |
"------------------------------------------" 

