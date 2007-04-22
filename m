Return-Path: <linux-kernel-owner+w=401wt.eu-S1030823AbXDVTuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030823AbXDVTuT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 15:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030820AbXDVTuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 15:50:19 -0400
Received: from ns3.system-techniques.com ([204.91.156.41]:50694 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030823AbXDVTuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 15:50:17 -0400
Date: Sun, 22 Apr 2007 12:50:16 -0700 (PDT)
From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
To: Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Subject: CPU 3: Machine Check Exception: 0000000000000004
Message-ID: <Pine.LNX.4.64.0704221230520.537@filesrv1.baby-dragons.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (ns3.baby-dragons.com [204.91.156.41]); Sun, 22 Apr 2007 19:50:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


 	Hello All ,  Has anyone else had an occurance of this hard lockup .
 	last time it was the scsi bus that was the last item on the console this 
time it's  CPU #3 ...
 	Everytime I try & run a bonnie on this system something locks the system 
up hard .  I do not trust this system at this time & need to put it into 
production soon .
 	Anybody any pointers    where to look , ... ?

Kernel: Linux 2.6.21-rc7 ,  unpatched .

<<<previous>>>
  root@filesrv1b:~ # CPU 3: Machine Check Exception: 0000000000000004
Kernel panic - not syncing: Unable to continue
Kernel panic - not syncing: Unable to continue

      +-A-+[ sc933s2 jbod chassis ] With 7-FUJITSU-MAP3147NC
      |
      +-B-+[ sc933s2 jbod chassis ] With 7-FUJITSU-MAP3147NC
      |
      + lsi22320 in pci-64-133 slot
[ system ] a SuperServer 6035B-8R
      + aic7902 on board
      |
      +-A-+[ internally ] With 2-Compaq/Seagate-18GB-u320 & 2-FUJITSU-MAP3147NC
      |
      +-B-+[ internally ] With 4-FUJITSU-MAP3147NC

 	lsi22320 is attached to the sc933s2 on channels A & B ,
 	cable lengths are ~ 4 feet on both channels .

 	aic7902 is attached internally thru 'system' ,  a SuperServer 6035B-8R .


  root@(none):~ # ( time bonnie++-1.03a/bonnie++ -u0:0 -d /home -s 524288 ) 2>&1
  | tee 512GB-bonnie++-run-ext3-200704181557.log
Using uid:0, gid:0.
Writing with putc()...mptscsih: ioc0: attempting task abort! (sc=d0795800)
sd 4:0:3:0:
         command: <4>mptscsih: ioc1: attempting task abort! (sc=d8c28500)
sd 5:0:1:0:
         command: Read(10): 28 00 00 1d d1 b9 00 00 08 00
Read(10): 28 00 00 1e 12 b9 00 00 08 00
mptscsih: ioc1: WARNING - TM Handler for type=1: IOC Not operational (0xffffffff)!
sd 1:0:3:0: Attempting to queue an A
<System Hung hard>

<<<\previous>>>



You can get the previous log here .
http://www.baby-dragons.com/new-sc933s2-coming-online-to-linux-scsi.log

 	Any help is greatly appreciated .
 		JimL

-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
