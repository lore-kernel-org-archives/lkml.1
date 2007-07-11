Return-Path: <linux-kernel-owner+w=401wt.eu-S1761610AbXGKKJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761610AbXGKKJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757126AbXGKKJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:09:45 -0400
Received: from foobar.is.scarlet.be ([195.95.3.133]:42359 "EHLO
	foobar.in.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690AbXGKKJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:09:44 -0400
X-Greylist: delayed 1633 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jul 2007 06:09:44 EDT
Message-ID: <4694A63E.1050606@scarlet.be>
Date: Wed, 11 Jul 2007 11:43:26 +0200
From: Benjamin Budts <benjamin.budts@scarlet.be>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: kvm-devel@lists.sourceforge.net
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: gcc + kvm + 64 bit ? confused :-/
References: <11838956891287-git-send-email-avi@qumranet.com>		<p73lkdqzpdm.fsf@bingen.suse.de> <4691D9C1.4050309@qumranet.com>		<20070709071640.GB10864@one.firstfloor.org>		<46920270.3080309@qumranet.com> <46921BE9.4040801@qumranet.com>		<a781481a0707091224s3fb1a2acr6d3ccce091480f61@mail.gmail.com>		<4693211D.4040406@qumranet.com>		<a781481a0707100222k4f204ed8gfd4823bc21b7bf25@mail.gmail.com>		<46936766.20900@qumranet.com>	<a781481a0707101707w121da1b7hc82dc0e3638e4570@mail.gmail.com> <46948626.6050308@qumranet.com>
In-Reply-To: <46948626.6050308@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Hi all,

question...

I'm a bit confused using the -march=xxx options for gcc when using a 
kernel virtual machine...
Getting errors on smp when using the -march=nocoma for gcc... possibly 
because smp is not fully supported yet I suppse.

I guess my question is, when installing kvm, is the virtual machine 64 
bit capable or should I install 32 bit OS ?

I installed an amd64 debian image and it seems to be running 
fine...except for the problem mentioned above.

And what type of architecture do i have to mention with gcc in a kvm ? 
march ... arch...

thx !

karnak:/usr/local/src/sendmail-8.14.1# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 2
model name      : QEMU Virtual CPU version 0.9.0
stepping        : 3
cpu MHz         : 1994.974
cache size      : 128 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 syscall lm up pni
bogomips        : 3929.02
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management:

