Return-Path: <linux-kernel-owner+w=401wt.eu-S1751975AbXCLW7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbXCLW7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 18:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbXCLW7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 18:59:33 -0400
Received: from denise.shiny.it ([194.20.232.1]:57833 "EHLO denise.shiny.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbXCLW7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 18:59:32 -0400
X-Greylist: delayed 659 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Mar 2007 18:59:32 EDT
Date: Mon, 12 Mar 2007 23:48:21 +0100 (CET)
From: Giuliano Pochini <pochini@denise.shiny.it>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: /sys/devices/system/cpu/cpuX/online are missing
In-Reply-To: <20070312085826.GA9985@osiris.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.64.0703122337350.25919@denise.shiny.it>
References: <20070311222652.5ea40da1.pochini@shiny.it>
 <20070312085826.GA9985@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Mar 2007, Heiko Carstens wrote:

> On Sun, Mar 11, 2007 at 10:26:52PM +0100, Giuliano Pochini wrote:
>>
>>
>> Since 2.6.20 /sys/devices/system/cpu/cpuX/online isn't there anymore. The
>> directories exist, though. I also tested linux-2.6.21rc3. I had a look at the
>> archives and I found nothing about the removal of that file, which is still
>> documented in Documentation/cpu-hotplug.txt. I don't know if other
>> architectures are affected.
>>
>> $ uname -a
>> Linux Jay 2.6.20 #1 SMP Mon Feb 5 22:42:18 CET 2007 ppc 7455, altivec supported PowerMac3,6 GNU/Linux
>>
>> No cpusets. CONFIG_HOTPLUG_CPU=y
>
> Somebody inverted the logic when and if the 'online' attribute for cpu devices
> appear. See 72486f1f8f0a2bc828b9d30cf4690cf2dd6807fc.
> The fix for s390 is this: 6721f77810dfcb7cbf8e97be6fa43fe2740dd0aa.
> Looks like arch/ppc was left out as well.

I had a look at arch/powerpc/kernel/smp.c but I'm not familiar at all with 
those parts of the kernel. I'm cc'ing this message to linuxppc-dev.


--
Giuliano.
