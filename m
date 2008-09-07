Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbYIGBiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbYIGBiH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 21:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYIGBhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 21:37:55 -0400
Received: from ns3.system-techniques.com ([204.91.156.41]:33165 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbYIGBhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 21:37:54 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Sep 2008 21:37:53 EDT
Date: Sat, 6 Sep 2008 17:31:11 -0800 (AKDT)
From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
To: "Moore, Eric" <Eric.Moore@lsi.com>,
       Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Subject: MPT Fusion ,  Continous whole card resets on 2.6.26.2 
Message-ID: <alpine.LNX.2.00.0809061705020.25246@filesrv1.baby-dragons.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.8 (ns3.baby-dragons.com [204.91.156.41]); Sun, 07 Sep 2008 01:31:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 	Hello Eric ,  All ,

 	I have this problem again after a long hiatus since some earlier 2.6 
kernels .
 	My main question is ;  Why does the silly driver not just fail the 
offending channel and be done with it ?

 	I've been just letting it roll & roll hoping to see it allow me to 
access my system & do some further diagnostics .  Wow it JUST finally timed out 
or something .  Full serial console log here ...

http://www.baby-dragons.com/2.6.26.2-mptfusion-rollandrolland.log

 	While I can understand had cables & all that beginning this kind of 
reset & retry ,  NOT the number of iterations .  IMO 3 times and your out . 
failing that making it a boot: time option that is settable .

 	Tia ,  JimL

fyi ,  8 times just for the disk device ,  2 times each for bus line & the WHOLE 
friggin card 8-( .

  root@(none):~ # dmesg | grep -i 'reset: SUCC'
mptscsih: ioc5: target reset: SUCCESS (sc=f6c26e80)
mptscsih: ioc5: bus reset: SUCCESS (sc=f6c26e80)
mptscsih: ioc5: host reset: SUCCESS (sc=f6c26e80)
mptscsih: ioc5: target reset: SUCCESS (sc=f6c26780)
mptscsih: ioc5: bus reset: SUCCESS (sc=f6c26780)
mptscsih: ioc5: host reset: SUCCESS (sc=f6c26780)
mptscsih: ioc5: target reset: SUCCESS (sc=f6db7c80)
mptscsih: ioc5: target reset: SUCCESS (sc=f6db7c80)
mptscsih: ioc5: target reset: SUCCESS (sc=f6db7c80)
mptscsih: ioc5: target reset: SUCCESS (sc=f6db7c80)
mptscsih: ioc5: target reset: SUCCESS (sc=f6db7c80)
mptscsih: ioc5: target reset: SUCCESS (sc=f6db7c80)



All bugs added by David S. Miller <davem@redhat.com>
SCTP: Hash tables configured (established 65536 bind 65536)
Starting balanced_irq
Using IPI No-Shortcut mode
registered taskstats version 1
scsi: waiting for bus probes to complete ...
mptscsih: ioc5: host reset: SUCCESS (sc=f6c26e80)
scsi 5:0:0:0: Device offlined - not ready after error recovery
  target5:0:0: Domain Validation detected failure, dropping back
  target4:0:0: Beginning Domain Validation
  target5:0:0: Domain Validation skipping write tests
  target5:0:0: Ending Domain Validation
  target5:0:0: asynchronous
  target4:0:0: Ending Domain Validation
scsi 5:0:1:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target4:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:1: Beginning Domain Validation
  target5:0:1: Beginning Domain Validation
  target4:0:1: Ending Domain Validation
  target4:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:2: Beginning Domain Validation
  target4:0:2: Ending Domain Validation
  target4:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:3: Beginning Domain Validation
  target4:0:3: Ending Domain Validation
  target4:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:4: Beginning Domain Validation
  target4:0:4: Ending Domain Validation
  target4:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:5: Beginning Domain Validation
  target4:0:5: Ending Domain Validation
  target4:0:5: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:6: Beginning Domain Validation
  target4:0:6: Ending Domain Validation
  target4:0:6: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:8: Beginning Domain Validation
  target4:0:8: Ending Domain Validation
  target4:0:8: asynchronous
mptscsih: ioc5: attempting task abort! (sc=f6c26780)
scsi 5:0:1:0: CDB: Inquiry: 12 00 00 00 60 00
mptscsih: ioc5: task abort: SUCCESS (sc=f6c26780)
mptscsih: ioc5: attempting task abort! (sc=f6c26780)
scsi 5:0:1:0: CDB: Test Unit Ready: 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f6c26780)
mptscsih: ioc5: attempting target reset! (sc=f6c26780)
scsi 5:0:1:0: CDB: Inquiry: 12 00 00 00 60 00
mptscsih: ioc5: target reset: SUCCESS (sc=f6c26780)
mptscsih: ioc5: attempting bus reset! (sc=f6c26780)
scsi 5:0:1:0: CDB: Inquiry: 12 00 00 00 60 00
mptscsih: ioc5: bus reset: SUCCESS (sc=f6c26780)
mptscsih: ioc5: attempting task abort! (sc=f6c26780)
scsi 5:0:1:0: CDB: Test Unit Ready: 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f6c26780)
mptscsih: ioc5: attempting host reset! (sc=f6c26780)
mptbase: ioc5: Initiating recovery
mptscsih: ioc5: host reset: SUCCESS (sc=f6c26780)
scsi 5:0:1:0: Device offlined - not ready after error recovery
  target4:0:0: Beginning Domain Validation
  target5:0:1: Domain Validation detected failure, dropping back
  target5:0:1: Domain Validation skipping write tests
  target5:0:1: Ending Domain Validation
  target5:0:1: asynchronous
scsi 5:0:2:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target5:0:2: Beginning Domain Validation
  target4:0:0: Ending Domain Validation
  target4:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:1: Beginning Domain Validation
  target4:0:1: Ending Domain Validation
  target4:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:2: Beginning Domain Validation
  target4:0:2: Ending Domain Validation
  target4:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:3: Beginning Domain Validation
  target4:0:3: Ending Domain Validation
  target4:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:4: Beginning Domain Validation
  target4:0:4: Ending Domain Validation
  target4:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:5: Beginning Domain Validation
  target4:0:5: Ending Domain Validation
  target4:0:5: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:6: Beginning Domain Validation
  target4:0:6: Ending Domain Validation
  target4:0:6: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:8: Beginning Domain Validation
  target4:0:8: Ending Domain Validation
  target4:0:8: asynchronous
mptscsih: ioc5: attempting task abort! (sc=f6db7c80)
scsi 5:0:2:0: CDB: Inquiry: 12 00 00 00 60 00
mptbase: ioc5: Initiating recovery
scsi 5:0:2:0: mptscsih: ioc5: completing cmds: fw_channel 0, fw_id 2, 
sc=f6db7c80, mf = f6405860, idx=81
mptscsih: ioc5: Issue of TaskMgmt failed!
mptscsih: ioc5: task abort: FAILED (sc=f6db7c80)
mptscsih: ioc5: attempting target reset! (sc=f6db7c80)
scsi 5:0:2:0: CDB: Inquiry: 12 00 00 00 60 00
  target4:0:0: Beginning Domain Validation
  target4:0:0: Ending Domain Validation
  target4:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:1: Beginning Domain Validation
  target4:0:1: Ending Domain Validation
  target4:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:2: Beginning Domain Validation
  target4:0:2: Ending Domain Validation
  target4:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:3: Beginning Domain Validation
  target4:0:3: Ending Domain Validation
  target4:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:4: Beginning Domain Validation
  target4:0:4: Ending Domain Validation
  target4:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:5: Beginning Domain Validation
  target4:0:5: Ending Domain Validation
  target4:0:5: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:6: Beginning Domain Validation
  target4:0:6: Ending Domain Validation
  target4:0:6: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:8: Beginning Domain Validation
  target4:0:8: Ending Domain Validation
  target4:0:8: asynchronous
mptscsih: ioc5: target reset: SUCCESS (sc=f6db7c80)
  target5:0:2: Domain Validation detected failure, dropping back
  target5:0:2: Domain Validation skipping write tests
  target5:0:2: Ending Domain Validation
  target5:0:2: asynchronous
scsi 5:0:3:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target5:0:3: Beginning Domain Validation
  target5:0:3: Domain Validation Disabing Information Units
  target5:0:3: Domain Validation detected failure, dropping back
scsi 5:0:3:0: Write Buffer failure 8000002
  target5:0:3: Domain Validation detected failure, dropping back
scsi 5:0:3:0: Write Buffer failure 80000
  target5:0:3: Domain Validation detected failure, dropping back
mptscsih: ioc5: attempting task abort! (sc=f6db7c80)
scsi 5:0:3:0: CDB: Write Buffer: 3b 0a 00 00 00 00 00 01 fc 00
mptbase: ioc5: Initiating recovery
scsi 5:0:3:0: mptscsih: ioc5: completing cmds: fw_channel 0, fw_id 3, 
sc=f6db7c80, mf = f6407360, idx=c9
mptscsih: ioc5: Issue of TaskMgmt failed!
mptscsih: ioc5: task abort: FAILED (sc=f6db7c80)
mptscsih: ioc5: attempting target reset! (sc=f6db7c80)
scsi 5:0:3:0: CDB: Write Buffer: 3b 0a 00 00 00 00 00 01 fc 00
  target4:0:0: Beginning Domain Validation
  target4:0:0: Ending Domain Validation
  target4:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:1: Beginning Domain Validation
  target4:0:1: Ending Domain Validation
  target4:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:2: Beginning Domain Validation
  target4:0:2: Ending Domain Validation
  target4:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:3: Beginning Domain Validation
  target4:0:3: Ending Domain Validation
  target4:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:4: Beginning Domain Validation
  target4:0:4: Ending Domain Validation
  target4:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:5: Beginning Domain Validation
  target4:0:5: Ending Domain Validation
  target4:0:5: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:6: Beginning Domain Validation
  target4:0:6: Ending Domain Validation
  target4:0:6: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:8: Beginning Domain Validation
  target4:0:8: Ending Domain Validation
  target4:0:8: asynchronous
mptscsih: ioc5: target reset: SUCCESS (sc=f6db7c80)
scsi 5:0:3:0: Write Buffer failure 80000
  target5:0:3: Domain Validation detected failure, dropping back
  target5:0:3: Ending Domain Validation
  target5:0:3: asynchronous
scsi 5:0:4:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target5:0:4: Beginning Domain Validation
mptscsih: ioc5: attempting task abort! (sc=f6db7c80)
scsi 5:0:4:0: CDB: Inquiry: 12 00 00 00 60 00
mptbase: ioc5: Initiating recovery
scsi 5:0:4:0: mptscsih: ioc5: completing cmds: fw_channel 0, fw_id 4, 
sc=f6db7c80, mf = f6408440, idx=f6
mptscsih: ioc5: Issue of TaskMgmt failed!
mptscsih: ioc5: task abort: FAILED (sc=f6db7c80)
mptscsih: ioc5: attempting target reset! (sc=f6db7c80)
scsi 5:0:4:0: CDB: Inquiry: 12 00 00 00 60 00
  target4:0:0: Beginning Domain Validation
  target4:0:0: Ending Domain Validation
  target4:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:1: Beginning Domain Validation
  target4:0:1: Ending Domain Validation
  target4:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:2: Beginning Domain Validation
  target4:0:2: Ending Domain Validation
  target4:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:3: Beginning Domain Validation
  target4:0:3: Ending Domain Validation
  target4:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:4: Beginning Domain Validation
  target4:0:4: Ending Domain Validation
  target4:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:5: Beginning Domain Validation
  target4:0:5: Ending Domain Validation
  target4:0:5: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:6: Beginning Domain Validation
  target4:0:6: Ending Domain Validation
  target4:0:6: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:8: Beginning Domain Validation
  target4:0:8: Ending Domain Validation
  target4:0:8: asynchronous
mptscsih: ioc5: target reset: SUCCESS (sc=f6db7c80)
  target5:0:4: Domain Validation detected failure, dropping back
  target5:0:4: Domain Validation skipping write tests
  target5:0:4: Ending Domain Validation
  target5:0:4: asynchronous
scsi 5:0:5:0: Direct-Access     ModusLnk MXJ3147SC800600X 5704 PQ: 0 ANSI: 3
  target5:0:5: Beginning Domain Validation
mptscsih: ioc5: attempting task abort! (sc=f6db7c80)
scsi 5:0:5:0: CDB: Inquiry: 12 00 00 00 60 00
mptbase: ioc5: Initiating recovery
scsi 5:0:5:0: mptscsih: ioc5: completing cmds: fw_channel 0, fw_id 5, 
sc=f6db7c80, mf = f6403580, idx=24
mptscsih: ioc5: Issue of TaskMgmt failed!
mptscsih: ioc5: task abort: FAILED (sc=f6db7c80)
mptscsih: ioc5: attempting target reset! (sc=f6db7c80)
scsi 5:0:5:0: CDB: Inquiry: 12 00 00 00 60 00
  target4:0:0: Beginning Domain Validation
  target4:0:0: Ending Domain Validation
  target4:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:1: Beginning Domain Validation
  target4:0:1: Ending Domain Validation
  target4:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:2: Beginning Domain Validation
  target4:0:2: Ending Domain Validation
  target4:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:3: Beginning Domain Validation
  target4:0:3: Ending Domain Validation
  target4:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:4: Beginning Domain Validation
  target4:0:4: Ending Domain Validation
  target4:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:5: Beginning Domain Validation
  target4:0:5: Ending Domain Validation
  target4:0:5: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:6: Beginning Domain Validation
  target4:0:6: Ending Domain Validation
  target4:0:6: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:8: Beginning Domain Validation
  target4:0:8: Ending Domain Validation
  target4:0:8: asynchronous
mptscsih: ioc5: target reset: SUCCESS (sc=f6db7c80)
  target5:0:5: Domain Validation detected failure, dropping back
  target5:0:5: Domain Validation skipping write tests
  target5:0:5: Ending Domain Validation
  target5:0:5: asynchronous
scsi 5:0:6:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target5:0:6: Beginning Domain Validation
mptscsih: ioc5: attempting task abort! (sc=f6db7c80)
scsi 5:0:6:0: CDB: Inquiry: 12 00 00 00 60 00
mptscsih: ioc5: task abort: SUCCESS (sc=f6db7c80)
mptscsih: ioc5: attempting task abort! (sc=f6db7c80)
scsi 5:0:6:0: CDB: Test Unit Ready: 00 00 00 00 00 00
mptbase: ioc5: Initiating recovery
scsi 5:0:6:0: mptscsih: ioc5: completing cmds: fw_channel 0, fw_id 6, 
sc=f6db7c80, mf = f6404780, idx=54
mptscsih: ioc5: Issue of TaskMgmt failed!
mptscsih: ioc5: task abort: FAILED (sc=f6db7c80)
mptscsih: ioc5: attempting target reset! (sc=f6db7c80)
scsi 5:0:6:0: CDB: Test Unit Ready: 00 00 00 00 00 00
  target4:0:0: Beginning Domain Validation
  target4:0:0: Ending Domain Validation
  target4:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:1: Beginning Domain Validation
  target4:0:1: Ending Domain Validation
  target4:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:2: Beginning Domain Validation
  target4:0:2: Ending Domain Validation
  target4:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:3: Beginning Domain Validation
  target4:0:3: Ending Domain Validation
  target4:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:4: Beginning Domain Validation
  target4:0:4: Ending Domain Validation
  target4:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:5: Beginning Domain Validation
  target4:0:5: Ending Domain Validation
  target4:0:5: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:6: Beginning Domain Validation
  target4:0:6: Ending Domain Validation
  target4:0:6: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target4:0:8: Beginning Domain Validation
  target4:0:8: Ending Domain Validation
  target4:0:8: asynchronous
mptscsih: ioc5: target reset: SUCCESS (sc=f6db7c80)
mptscsih: ioc5: attempting target reset! (sc=f6db7c80)
scsi 5:0:6:0: CDB: Inquiry: 12 00 00 00 60 00
mptscsih: ioc5: target reset: SUCCESS (sc=f6db7c80)
  target5:0:6: Domain Validation detected failure, dropping back
  target5:0:6: Domain Validation skipping write tests
  target5:0:6: Ending Domain Validation
  target5:0:6: asynchronous
scsi 5:0:8:0: Processor         SUPER    GEM359 REV001    1.09 PQ: 0 ANSI: 2
  target5:0:8: Beginning Domain Validation
  target5:0:8: Ending Domain Validation
  target5:0:8: asynchronous
sd 5:0:0:0: [sdr] 287132440 512-byte hardware sectors (147012 MB)
sd 5:0:0:0: [sdr] Write Protect is off
sd 5:0:0:0: [sdr] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
sd 5:0:0:0: [sdr] 287132440 512-byte hardware sectors (147012 MB)
sd 5:0:0:0: [sdr] Write Protect is off
sd 5:0:0:0: [sdr] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdr: unknown partition table
sd 5:0:0:0: [sdr] Attached SCSI disk
sd 5:0:0:0: Attached scsi generic sg20 type 0
sd 5:0:1:0: [sds] Spinning up 
disk.....................................................................................................not 
responding...
mptscsih: ioc5: attempting task abort! (sc=f6db7c80)
sd 5:0:1:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f6db7c80)
mptscsih: ioc5: attempting task abort! (sc=f6db7c80)
sd 5:0:1:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f6db7c80)
mptscsih: ioc5: attempting task abort! (sc=f6db7c80)
sd 5:0:1:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f6db7c80)
mptscsih: ioc5: attempting task abort! (sc=f6db7c80)
sd 5:0:1:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f6db7c80)
mptscsih: ioc5: attempting task abort! (sc=f6db7c80)
sd 5:0:1:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f6db7c80)
mptscsih: ioc5: attempting task abort! (sc=f6db7c80)
sd 5:0:1:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f6db7c80)
mptscsih: ioc5: attempting task abort! (sc=f6db7e80)
sd 5:0:1:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f6db7e80)
mptscsih: ioc5: attempting task abort! (sc=f6db7e80)
sd 5:0:1:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f6db7e80)
mptscsih: ioc5: attempting task abort! (sc=f6db7e80)
sd 5:0:1:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f6db7e80)
mptscsih: ioc5: attempting task abort! (sc=f6db7e80)
sd 5:0:1:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f6db7e80)
mptscsih: ioc5: attempting task abort! (sc=f6db7e80)
sd 5:0:1:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f6db7e80)
mptscsih: ioc5: attempting task abort! (sc=f6db7e80)
sd 5:0:1:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f6db7e80)
mptscsih: ioc5: attempting task abort! (sc=f68c7780)
sd 5:0:1:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f68c7780)
mptscsih: ioc5: attempting task abort! (sc=f68c7780)
sd 5:0:1:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f68c7780)
mptscsih: ioc5: attempting task abort! (sc=f68c7780)
sd 5:0:1:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f68c7780)
mptscsih: ioc5: attempting task abort! (sc=f68c7780)
sd 5:0:1:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f68c7780)
mptscsih: ioc5: attempting task abort! (sc=f68c7780)
sd 5:0:1:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f68c7780)
mptscsih: ioc5: attempting task abort! (sc=f68c7780)
sd 5:0:1:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
mptscsih: ioc5: task abort: SUCCESS (sc=f68c7780)
sd 5:0:1:0: [sds] READ CAPACITY failed
sd 5:0:1:0: [sds] Result: hostbyte=DID_RESET driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 5:0:1:0: [sds] Sense Key : Not Ready [current]
sd 5:0:1:0: [sds] Add. Sense: Logical unit is in process of becoming ready



-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
