Return-Path: <linux-kernel-owner+w=401wt.eu-S1764475AbXESVIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764475AbXESVIA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 17:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758735AbXESVHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 17:07:53 -0400
Received: from ns.armcci.am ([195.250.88.164]:42598 "EHLO ns.armcci.am"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758637AbXESVHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 17:07:52 -0400
Date: Sun, 20 May 2007 02:07:41 +0500 (AMST)
From: eugene@ns.armcci.am
To: Bernd Eckenfels <ecki@lina.inka.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: ht CPU flag
In-Reply-To: <E1Hp982-0002Mp-00@calista.eckenfels.net>
Message-ID: <Pine.LNX.4.64.0705200126240.3105@ns.armcci.am>
References: <E1Hp982-0002Mp-00@calista.eckenfels.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> To authors of /proc/cpuinfo:
>>
>> Plz, fix stepping identification:

>It might be a bug in the kernel code, however it is pretty unlikely: It just
>reads what the CPU reports. You have an odd chip, nothing what the kernel
>can do about. I see "family 15, model 2, stepping 4" usually beeing a P4
>2.4GHz CPU. Maybe thats one of those relabling cases.

>The information you list is a dual-cpu with HT configuration.

>You could give us the output of any of your windows tools, but I am quite
>sure they will report the same thing.

>Greetings
>Bernd

The problem of getting windows utility output now is that it's the server 
in the datacenter, running 24/7 for many users. That's why I wanted to 
find out everything just in Linux.

This server is on Intel mainboard with Intel chassis, but it's not 
compatible with Win2k3, that's why they gave it to me for Linux :) 
Sometimes it's unstable under Linux too. I feel that the problem is in the 
hardware, may be CPU settings, cache etc... I set "acpi=ht pci=routeirq" 
to make it work at all. It has newest available BIOS installed.

Here is what Intel say about supported CPUs for this mobo:

SL623	2 GHz	N/A	N/A	400 MHz	0.13 micron	B0	512 KB 
Micro-FCPGA 0F24
SL5Z9	2 GHz	N/A	N/A	400 MHz	0.13 micron	B0	512 KB 
Micro-FCPGA 0F24
SL6YT	2 GHz	N/A	N/A	400 MHz	0.13 micron	D1	512 KB 
Micro-FCPGA 0F29h
SL6JY	2 GHz	N/A	N/A	400 MHz	0.13 micron	C1	512 KB 
Micro-FCPGA 0F27h

But none of them has HT! And my configuration - has! It's a puzzle for me.


>> From now I'll use Intel recomendation to run their utility to resolve all
>> questions.

>You mean this, right?

>http://www.intel.com/support/proces...b/cs-001632.htm

>Greetings
>Bernd

Yeah. Definitely Intel has some secret tables to identify CPU :)
