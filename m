Return-Path: <linux-kernel-owner+w=401wt.eu-S933893AbYBWLao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933893AbYBWLao (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 06:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYBWLag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 06:30:36 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:56956 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbYBWLaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 06:30:35 -0500
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Feb 2008 06:30:35 EST
Date: Sat, 23 Feb 2008 12:20:12 +0100 (CET)
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: linux-kernel@vger.kernel.org
Subject: arcmsr & areca-1660 - strange behaviour under heavy load
Message-ID: <alpine.LRH.0.9999.0802231201380.21313@linuxbox.linuxbox.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Antivirus: on proxybox by Kaspersky antivirus, engine 5.5.10, data 533331 records(23-02-2008)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've found strange problem either in arcmsr driver, or maybe in 
areca-1660 card...
When system on SAS discs RAID connected to areca-1660 card 
gets under heavy I/O load, it gets unusable after some time. I can 100% reproduce 
this, although it needs quite speciffic conditions:
It can be reproduced on 2x quad core machine, RAM has to be limited to 
~192MB to cause heavy paging.
Only thing needed to cause the problem is to start loop doing kernel 
compilation using make -j 8 - this loads the system heavily, because of 
lack of memory. After few correct compile runs the system gets into 
state when all programs including the basic ones (ls, cp, ..) start 
crashing... dmesg (when it works) doesn't say anything strange...
After reboot, the system is OK again.
I have tested it on different motherboards, with different CPUs, RAMs(all 
were properly tested with memtest), with two different areca cards and 
different drives. I can't reproduce the problem on same hardware when 
using different RAID card (ie adaptec). All testing systems were properly 
cooled..
I have tried all available areca firmwares, two different distributions 
(oracle linux, and centos), and kernels ranging from distribution ones, to last GIT snapshot.
Could somebody please give me some hints on how to hunt this problem?
Areca support doesn't seem to be very interested in the problem :-(
Thanks a lot in advance
BR
nik

-------------------------------------
Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

