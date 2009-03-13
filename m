Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbZCMO4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbZCMO4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 10:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbZCMO4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 10:56:12 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:60173 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbZCMO4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 10:56:12 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
Subject: Re: Linux* Processor Microcode Data File
Date: Fri, 13 Mar 2009 10:55:44 -0400
User-Agent: KMail/1.11.0 (Linux/2.6.28.7; KDE/4.2.0; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com>
 <2d05c4580903130142o2e5ebbcfw1e35eb52ea48e4b1@mail.gmail.com>
 <2d05c4580903130144t8e92950l7a6cb1078a8a577b@mail.gmail.com>
In-reply-to: <2d05c4580903130144t8e92950l7a6cb1078a8a577b@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200903131055.44150.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 March 2009, Dragoslav Zaric wrote:
>---------------------------------------------
>I found this on web site http://kerneltrap.org
>
>Tigran Aivazian, author of the IA32 microcode driver and Microcode
>Update Utility for Linux explained:
>
>"The answer to your question is that some Intel CPUs (just like any
>other hardware or software) contain bugs
>and, fortunately, their architecture is flexible enough to provide a
>way to fix those bugs by means of loading the
>microcode update on the fly, i.e. while the OS is running with no need
>to reboot (in fact, rebooting or otherwise
>resetting the CPU causes the update to be lost and requires to run the
>update again)."

And what runs this update?  I saw it apply once in the dmesg output, about 3 
full powerdown reboots ago, never since, and the code is still there in 
/lib/firmware

AMD quad core 9550 here, stepping 03.

Thanks.
>---------------------------------------------
>
>So when you reboot system, you reset CPU to original state, and after
>that you must apply microcode, and this
>is what is actually doing right now, you put microcode in folder
>/etc/firmware and after boot microcode is loaded.
>
>So I think for CPU hotplug it is also natural that microcode is loaded
>after plugging, because you can not use
>microcode from boot process. Maybe kernel should have database of
>tested microcodes, so when you plug CPU
>appropriate microcode is loaded.


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The only thing that experience teaches us is that experience teaches us 
nothing.
		-- Andre Maurois (Emile Herzog)

