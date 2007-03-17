Return-Path: <linux-kernel-owner+w=401wt.eu-S933762AbXCQM5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762AbXCQM5O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 08:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933807AbXCQM5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 08:57:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:52998 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933762AbXCQM5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 08:57:13 -0400
From: Christian <christiand59@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: SATA problems in 2.6.20.3
Date: Sat, 17 Mar 2007 13:55:47 +0100
User-Agent: KMail/1.9.6
References: <20070316113657.161e5315@daydream.goid.lan>
In-Reply-To: <20070316113657.161e5315@daydream.goid.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703171355.47687.christiand59@web.de>
X-Provags-ID: V01U2FsdGVkX1/+MyzoLkldc/FBlVAsOCPXSmblhTs80Jy/RK9
 +o2PG103d1PTk1UT20Q4mTYxfBTNoW4ouaRXbwEQwArh9hBzZp
 zQBVP9lIzuFD13cYguk3A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing the same here since a few days. Before it worked great (even with 
NCQ). I've been getting those messages since 2.6.21-rc3-mm1 and with the 
latest Ubuntu feisty kernel (2.6.20-11-generic #2 SMP Thu Mar 15 03:43:56 UTC 
2007 x86_64 GNU/Linux)

System is Athlon64 X2, Nforce4, 3x Samsung SATA II NCQ discs.

[10802.844891] ata1: soft resetting port
[10802.922845] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[10802.966231] ata1.00: Host Protected Area detected:
[10802.966232]  current size: 781422768 sectors (400 GB)
[10802.966233]  native size: -1349283664 sectors (18446743382 GB)
[10802.966237] ata1.00: configured for UDMA/133
[10802.966265] ata1: EH complete
[10817.958196] ata1: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 
0x1501000 status 0x400
[10817.958201] ata1: CPB 0: ctl_flags 0x1f, resp_flags 0x0
[10817.958203] ata1: CPB 1: ctl_flags 0x1f, resp_flags 0x0
[10817.958205] ata1: CPB 2: ctl_flags 0x1f, resp_flags 0x0
[10817.958206] ata1: CPB 3: ctl_flags 0x1f, resp_flags 0x0
[10817.958208] ata1: CPB 4: ctl_flags 0x1f, resp_flags 0x0
[10817.958210] ata1: CPB 5: ctl_flags 0x1f, resp_flags 0x0
[10817.958211] ata1: CPB 6: ctl_flags 0x1f, resp_flags 0x0
[10817.958213] ata1: CPB 7: ctl_flags 0x1f, resp_flags 0x0
[10817.958215] ata1: CPB 8: ctl_flags 0x1f, resp_flags 0x0
[10817.958216] ata1: CPB 9: ctl_flags 0x1f, resp_flags 0x0
[10817.958218] ata1: CPB 10: ctl_flags 0x1f, resp_flags 0x0
[10817.958220] ata1: CPB 11: ctl_flags 0x1f, resp_flags 0x0
[10817.958222] ata1: CPB 12: ctl_flags 0x1f, resp_flags 0x0
[10817.958224] ata1: CPB 13: ctl_flags 0x1f, resp_flags 0x0
[10817.958225] ata1: CPB 14: ctl_flags 0x1f, resp_flags 0x0
[10817.958227] ata1: CPB 15: ctl_flags 0x1f, resp_flags 0x0
[10817.958229] ata1: CPB 16: ctl_flags 0x1f, resp_flags 0x0
[10817.958231] ata1: CPB 17: ctl_flags 0x1f, resp_flags 0x0
[10817.958233] ata1: CPB 18: ctl_flags 0x1f, resp_flags 0x0
[10817.958235] ata1: CPB 19: ctl_flags 0x1f, resp_flags 0x0
[10817.958236] ata1: CPB 20: ctl_flags 0x1f, resp_flags 0x0
[10817.958238] ata1: CPB 21: ctl_flags 0x1f, resp_flags 0x0
[10817.958240] ata1: CPB 22: ctl_flags 0x1f, resp_flags 0x0
[10817.958242] ata1: CPB 23: ctl_flags 0x1f, resp_flags 0x0
[10817.958244] ata1: CPB 24: ctl_flags 0x1f, resp_flags 0x0
[10817.958245] ata1: CPB 25: ctl_flags 0x1f, resp_flags 0x0
[10817.958247] ata1: CPB 26: ctl_flags 0x1f, resp_flags 0x0
[10817.958249] ata1: CPB 27: ctl_flags 0x1f, resp_flags 0x0
[10817.958250] ata1: CPB 28: ctl_flags 0x1f, resp_flags 0x0
[10817.958252] ata1: CPB 29: ctl_flags 0x1f, resp_flags 0x0
[10817.958254] ata1: CPB 30: ctl_flags 0x1f, resp_flags 0x0
[10817.958256] ata1: Resetting port
[10817.958262] ata1.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 
0x2 frozen
[10817.958267] ata1.00: cmd 61/00:00:c7:6b:46/02:00:02:00:00/40 tag 0 cdb 0x0 
data 262144 out
[10817.958268]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958272] ata1.00: cmd 61/00:08:c7:6d:46/02:00:02:00:00/40 tag 1 cdb 0x0 
data 262144 out
[10817.958274]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958278] ata1.00: cmd 61/00:10:c7:6f:46/04:00:02:00:00/40 tag 2 cdb 0x0 
data 524288 out
[10817.958279]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958283] ata1.00: cmd 61/00:18:c7:73:46/02:00:02:00:00/40 tag 3 cdb 0x0 
data 262144 out
[10817.958285]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958289] ata1.00: cmd 61/00:20:c7:75:46/04:00:02:00:00/40 tag 4 cdb 0x0 
data 524288 out
[10817.958290]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958294] ata1.00: cmd 61/00:28:c7:79:46/02:00:02:00:00/40 tag 5 cdb 0x0 
data 262144 out
[10817.958296]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958300] ata1.00: cmd 61/00:30:c7:7b:46/02:00:02:00:00/40 tag 6 cdb 0x0 
data 262144 out
[10817.958301]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958305] ata1.00: cmd 61/08:38:c7:7f:46/00:00:02:00:00/40 tag 7 cdb 0x0 
data 4096 out
[10817.958307]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958311] ata1.00: cmd 61/00:40:c7:7d:46/02:00:02:00:00/40 tag 8 cdb 0x0 
data 262144 out
[10817.958312]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958316] ata1.00: cmd 61/00:48:cf:7f:46/02:00:02:00:00/40 tag 9 cdb 0x0 
data 262144 out
[10817.958317]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958322] ata1.00: cmd 61/00:50:cf:81:46/02:00:02:00:00/40 tag 10 cdb 0x0 
data 262144 out
[10817.958323]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958327] ata1.00: cmd 61/00:58:cf:83:46/02:00:02:00:00/40 tag 11 cdb 0x0 
data 262144 out
[10817.958328]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958333] ata1.00: cmd 61/00:60:cf:85:46/02:00:02:00:00/40 tag 12 cdb 0x0 
data 262144 out
[10817.958334]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958338] ata1.00: cmd 61/00:68:cf:87:46/04:00:02:00:00/40 tag 13 cdb 0x0 
data 524288 out
[10817.958339]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958344] ata1.00: cmd 61/00:70:cf:8b:46/04:00:02:00:00/40 tag 14 cdb 0x0 
data 524288 out
[10817.958345]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958349] ata1.00: cmd 61/00:78:cf:8f:46/02:00:02:00:00/40 tag 15 cdb 0x0 
data 262144 out
[10817.958350]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958355] ata1.00: cmd 61/00:80:cf:91:46/02:00:02:00:00/40 tag 16 cdb 0x0 
data 262144 out
[10817.958356]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958360] ata1.00: cmd 61/00:88:cf:93:46/02:00:02:00:00/40 tag 17 cdb 0x0 
data 262144 out
[10817.958362]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958366] ata1.00: cmd 61/00:90:cf:95:46/04:00:02:00:00/40 tag 18 cdb 0x0 
data 524288 out
[10817.958367]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958371] ata1.00: cmd 61/00:98:cf:99:46/02:00:02:00:00/40 tag 19 cdb 0x0 
data 262144 out
[10817.958373]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958377] ata1.00: cmd 61/00:a0:cf:9b:46/02:00:02:00:00/40 tag 20 cdb 0x0 
data 262144 out
[10817.958378]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958382] ata1.00: cmd 61/08:a8:cf:9d:46/02:00:02:00:00/40 tag 21 cdb 0x0 
data 266240 out
[10817.958384]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958388] ata1.00: cmd 61/00:b0:d7:9f:46/02:00:02:00:00/40 tag 22 cdb 0x0 
data 262144 out
[10817.958389]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958393] ata1.00: cmd 61/00:b8:d7:a1:46/02:00:02:00:00/40 tag 23 cdb 0x0 
data 262144 out
[10817.958395]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958399] ata1.00: cmd 61/00:c0:d7:a3:46/04:00:02:00:00/40 tag 24 cdb 0x0 
data 524288 out
[10817.958400]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958404] ata1.00: cmd 61/00:c8:d7:a7:46/02:00:02:00:00/40 tag 25 cdb 0x0 
data 262144 out
[10817.958406]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958410] ata1.00: cmd 61/00:d0:d7:a9:46/02:00:02:00:00/40 tag 26 cdb 0x0 
data 262144 out
[10817.958411]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958415] ata1.00: cmd 61/00:d8:d7:ab:46/02:00:02:00:00/40 tag 27 cdb 0x0 
data 262144 out
[10817.958417]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958421] ata1.00: cmd 61/00:e0:d7:ad:46/04:00:02:00:00/40 tag 28 cdb 0x0 
data 524288 out
[10817.958422]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958426] ata1.00: cmd 61/00:e8:d7:b1:46/02:00:02:00:00/40 tag 29 cdb 0x0 
data 262144 out
[10817.958428]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10817.958432] ata1.00: cmd 61/00:f0:d7:b3:46/02:00:02:00:00/40 tag 30 cdb 0x0 
data 262144 out
[10817.958433]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10818.114100] ata1: soft resetting port
[10818.192059] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[10818.237135] ata1.00: Host Protected Area detected:
[10818.237137]  current size: 781422768 sectors (400 GB)
[10818.237138]  native size: -1349283664 sectors (18446743382 GB)
[10818.237142] ata1.00: configured for UDMA/133
[10818.237171] ata1: EH complete
[10833.229410] ata1: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 
0x1501000 status 0x400
[10833.229415] ata1: CPB 0: ctl_flags 0x1f, resp_flags 0x0
[10833.229418] ata1: CPB 1: ctl_flags 0x1f, resp_flags 0x0
[10833.229420] ata1: CPB 2: ctl_flags 0x1f, resp_flags 0x0
[10833.229422] ata1: CPB 3: ctl_flags 0x1f, resp_flags 0x0
[10833.229423] ata1: CPB 4: ctl_flags 0x1f, resp_flags 0x0
[10833.229426] ata1: CPB 5: ctl_flags 0x1f, resp_flags 0x0
[10833.229428] ata1: CPB 6: ctl_flags 0x1f, resp_flags 0x0
[10833.229430] ata1: CPB 7: ctl_flags 0x1f, resp_flags 0x0
[10833.229432] ata1: CPB 8: ctl_flags 0x1f, resp_flags 0x0
[10833.229434] ata1: CPB 9: ctl_flags 0x1f, resp_flags 0x0
[10833.229436] ata1: CPB 10: ctl_flags 0x1f, resp_flags 0x0
[10833.229439] ata1: CPB 11: ctl_flags 0x1f, resp_flags 0x0
[10833.229441] ata1: CPB 12: ctl_flags 0x1f, resp_flags 0x0
[10833.229443] ata1: CPB 13: ctl_flags 0x1f, resp_flags 0x0
[10833.229445] ata1: CPB 14: ctl_flags 0x1f, resp_flags 0x0
[10833.229448] ata1: CPB 15: ctl_flags 0x1f, resp_flags 0x0
[10833.229450] ata1: CPB 16: ctl_flags 0x1f, resp_flags 0x0
[10833.229452] ata1: CPB 17: ctl_flags 0x1f, resp_flags 0x0
[10833.229454] ata1: CPB 18: ctl_flags 0x1f, resp_flags 0x0
[10833.229456] ata1: CPB 19: ctl_flags 0x1f, resp_flags 0x0
[10833.229459] ata1: CPB 20: ctl_flags 0x1f, resp_flags 0x0
[10833.229461] ata1: CPB 21: ctl_flags 0x1f, resp_flags 0x0
[10833.229463] ata1: CPB 22: ctl_flags 0x1f, resp_flags 0x0
[10833.229465] ata1: CPB 23: ctl_flags 0x1f, resp_flags 0x0
[10833.229468] ata1: CPB 24: ctl_flags 0x1f, resp_flags 0x0
[10833.229470] ata1: CPB 25: ctl_flags 0x1f, resp_flags 0x0
[10833.229472] ata1: CPB 26: ctl_flags 0x1f, resp_flags 0x0
[10833.229474] ata1: CPB 27: ctl_flags 0x1f, resp_flags 0x0
[10833.229476] ata1: CPB 28: ctl_flags 0x1f, resp_flags 0x0
[10833.229479] ata1: CPB 29: ctl_flags 0x1f, resp_flags 0x0
[10833.229481] ata1: CPB 30: ctl_flags 0x1f, resp_flags 0x0
[10833.229483] ata1: Resetting port
[10833.229489] ata1.00: limiting speed to UDMA/100
[10833.229493] ata1.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 
0x2 frozen
[10833.229497] ata1.00: cmd 61/00:00:d7:b3:46/02:00:02:00:00/40 tag 0 cdb 0x0 
data 262144 out
[10833.229499]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229503] ata1.00: cmd 61/00:08:d7:b1:46/02:00:02:00:00/40 tag 1 cdb 0x0 
data 262144 out
[10833.229505]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229509] ata1.00: cmd 61/00:10:d7:ad:46/04:00:02:00:00/40 tag 2 cdb 0x0 
data 524288 out
[10833.229511]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229515] ata1.00: cmd 61/00:18:d7:ab:46/02:00:02:00:00/40 tag 3 cdb 0x0 
data 262144 out
[10833.229517]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229521] ata1.00: cmd 61/00:20:d7:a9:46/02:00:02:00:00/40 tag 4 cdb 0x0 
data 262144 out
[10833.229522]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229527] ata1.00: cmd 61/00:28:d7:a7:46/02:00:02:00:00/40 tag 5 cdb 0x0 
data 262144 out
[10833.229528]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229533] ata1.00: cmd 61/00:30:d7:a3:46/04:00:02:00:00/40 tag 6 cdb 0x0 
data 524288 out
[10833.229534]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229539] ata1.00: cmd 61/00:38:d7:a1:46/02:00:02:00:00/40 tag 7 cdb 0x0 
data 262144 out
[10833.229540]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229545] ata1.00: cmd 61/00:40:d7:9f:46/02:00:02:00:00/40 tag 8 cdb 0x0 
data 262144 out
[10833.229546]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229550] ata1.00: cmd 61/08:48:cf:9d:46/02:00:02:00:00/40 tag 9 cdb 0x0 
data 266240 out
[10833.229552]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229556] ata1.00: cmd 61/00:50:cf:9b:46/02:00:02:00:00/40 tag 10 cdb 0x0 
data 262144 out
[10833.229558]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229562] ata1.00: cmd 61/00:58:cf:99:46/02:00:02:00:00/40 tag 11 cdb 0x0 
data 262144 out
[10833.229564]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229568] ata1.00: cmd 61/00:60:cf:95:46/04:00:02:00:00/40 tag 12 cdb 0x0 
data 524288 out
[10833.229569]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229574] ata1.00: cmd 61/00:68:cf:93:46/02:00:02:00:00/40 tag 13 cdb 0x0 
data 262144 out
[10833.229575]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229580] ata1.00: cmd 61/00:70:cf:91:46/02:00:02:00:00/40 tag 14 cdb 0x0 
data 262144 out
[10833.229581]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229585] ata1.00: cmd 61/00:78:cf:8f:46/02:00:02:00:00/40 tag 15 cdb 0x0 
data 262144 out
[10833.229587]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229591] ata1.00: cmd 61/00:80:cf:8b:46/04:00:02:00:00/40 tag 16 cdb 0x0 
data 524288 out
[10833.229593]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229597] ata1.00: cmd 61/00:88:cf:87:46/04:00:02:00:00/40 tag 17 cdb 0x0 
data 524288 out
[10833.229599]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229603] ata1.00: cmd 61/00:90:cf:85:46/02:00:02:00:00/40 tag 18 cdb 0x0 
data 262144 out
[10833.229604]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229609] ata1.00: cmd 61/00:98:cf:83:46/02:00:02:00:00/40 tag 19 cdb 0x0 
data 262144 out
[10833.229610]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229615] ata1.00: cmd 61/00:a0:cf:81:46/02:00:02:00:00/40 tag 20 cdb 0x0 
data 262144 out
[10833.229616]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229621] ata1.00: cmd 61/00:a8:cf:7f:46/02:00:02:00:00/40 tag 21 cdb 0x0 
data 262144 out
[10833.229622]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229626] ata1.00: cmd 61/00:b0:c7:7d:46/02:00:02:00:00/40 tag 22 cdb 0x0 
data 262144 out
[10833.229628]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229632] ata1.00: cmd 61/08:b8:c7:7f:46/00:00:02:00:00/40 tag 23 cdb 0x0 
data 4096 out
[10833.229634]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229638] ata1.00: cmd 61/00:c0:c7:7b:46/02:00:02:00:00/40 tag 24 cdb 0x0 
data 262144 out
[10833.229639]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229644] ata1.00: cmd 61/00:c8:c7:79:46/02:00:02:00:00/40 tag 25 cdb 0x0 
data 262144 out
[10833.229645]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229650] ata1.00: cmd 61/00:d0:c7:75:46/04:00:02:00:00/40 tag 26 cdb 0x0 
data 524288 out
[10833.229651]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229655] ata1.00: cmd 61/00:d8:c7:73:46/02:00:02:00:00/40 tag 27 cdb 0x0 
data 262144 out
[10833.229657]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229661] ata1.00: cmd 61/00:e0:c7:6f:46/04:00:02:00:00/40 tag 28 cdb 0x0 
data 524288 out
[10833.229663]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229667] ata1.00: cmd 61/00:e8:c7:6d:46/02:00:02:00:00/40 tag 29 cdb 0x0 
data 262144 out
[10833.229669]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.229673] ata1.00: cmd 61/00:f0:c7:6b:46/02:00:02:00:00/40 tag 30 cdb 0x0 
data 262144 out
[10833.229674]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10833.385313] ata1: soft resetting port
[10833.463272] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[10833.507178] ata1.00: Host Protected Area detected:
[10833.507179]  current size: 781422768 sectors (400 GB)
[10833.507180]  native size: -1349283664 sectors (18446743382 GB)
[10833.507186] ata1.00: configured for UDMA/100
[10833.507215] ata1: EH complete
[10848.498629] ata1: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 
0x1501000 status 0x400
[10848.498634] ata1: CPB 0: ctl_flags 0x1f, resp_flags 0x0
[10848.498637] ata1: CPB 1: ctl_flags 0x1f, resp_flags 0x0
[10848.498639] ata1: CPB 2: ctl_flags 0x1f, resp_flags 0x0
[10848.498641] ata1: CPB 3: ctl_flags 0x1f, resp_flags 0x0
[10848.498642] ata1: CPB 4: ctl_flags 0x1f, resp_flags 0x0
[10848.498644] ata1: CPB 5: ctl_flags 0x1f, resp_flags 0x0
[10848.498646] ata1: CPB 6: ctl_flags 0x1f, resp_flags 0x0
[10848.498649] ata1: CPB 7: ctl_flags 0x1f, resp_flags 0x0
[10848.498651] ata1: CPB 8: ctl_flags 0x1f, resp_flags 0x0
[10848.498653] ata1: CPB 9: ctl_flags 0x1f, resp_flags 0x0
[10848.498655] ata1: CPB 10: ctl_flags 0x1f, resp_flags 0x0
[10848.498657] ata1: CPB 11: ctl_flags 0x1f, resp_flags 0x0
[10848.498659] ata1: CPB 12: ctl_flags 0x1f, resp_flags 0x0
[10848.498662] ata1: CPB 13: ctl_flags 0x1f, resp_flags 0x0
[10848.498664] ata1: CPB 14: ctl_flags 0x1f, resp_flags 0x0
[10848.498666] ata1: CPB 15: ctl_flags 0x1f, resp_flags 0x0
[10848.498668] ata1: CPB 16: ctl_flags 0x1f, resp_flags 0x0
[10848.498670] ata1: CPB 17: ctl_flags 0x1f, resp_flags 0x0
[10848.498673] ata1: CPB 18: ctl_flags 0x1f, resp_flags 0x0
[10848.498675] ata1: CPB 19: ctl_flags 0x1f, resp_flags 0x0
[10848.498677] ata1: CPB 20: ctl_flags 0x1f, resp_flags 0x0
[10848.498679] ata1: CPB 21: ctl_flags 0x1f, resp_flags 0x0
[10848.498681] ata1: CPB 22: ctl_flags 0x1f, resp_flags 0x0
[10848.498684] ata1: CPB 23: ctl_flags 0x1f, resp_flags 0x0
[10848.498686] ata1: CPB 24: ctl_flags 0x1f, resp_flags 0x0
[10848.498688] ata1: CPB 25: ctl_flags 0x1f, resp_flags 0x0
[10848.498690] ata1: CPB 26: ctl_flags 0x1f, resp_flags 0x0
[10848.498692] ata1: CPB 27: ctl_flags 0x1f, resp_flags 0x0
[10848.498695] ata1: CPB 28: ctl_flags 0x1f, resp_flags 0x0
[10848.498697] ata1: CPB 29: ctl_flags 0x1f, resp_flags 0x0
[10848.498699] ata1: CPB 30: ctl_flags 0x1f, resp_flags 0x0
[10848.498701] ata1: Resetting port
[10848.498708] ata1.00: limiting speed to UDMA/66
[10848.498711] ata1.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 
0x2 frozen
[10848.498715] ata1.00: cmd 61/00:00:c7:6b:46/02:00:02:00:00/40 tag 0 cdb 0x0 
data 262144 out
[10848.498717]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498721] ata1.00: cmd 61/00:08:c7:6d:46/02:00:02:00:00/40 tag 1 cdb 0x0 
data 262144 out
[10848.498723]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498727] ata1.00: cmd 61/00:10:c7:6f:46/04:00:02:00:00/40 tag 2 cdb 0x0 
data 524288 out
[10848.498729]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498733] ata1.00: cmd 61/00:18:c7:73:46/02:00:02:00:00/40 tag 3 cdb 0x0 
data 262144 out
[10848.498735]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498739] ata1.00: cmd 61/00:20:c7:75:46/04:00:02:00:00/40 tag 4 cdb 0x0 
data 524288 out
[10848.498740]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498745] ata1.00: cmd 61/00:28:c7:79:46/02:00:02:00:00/40 tag 5 cdb 0x0 
data 262144 out
[10848.498746]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498751] ata1.00: cmd 61/00:30:c7:7b:46/02:00:02:00:00/40 tag 6 cdb 0x0 
data 262144 out
[10848.498752]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498757] ata1.00: cmd 61/08:38:c7:7f:46/00:00:02:00:00/40 tag 7 cdb 0x0 
data 4096 out
[10848.498758]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498763] ata1.00: cmd 61/00:40:c7:7d:46/02:00:02:00:00/40 tag 8 cdb 0x0 
data 262144 out
[10848.498764]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498768] ata1.00: cmd 61/00:48:cf:7f:46/02:00:02:00:00/40 tag 9 cdb 0x0 
data 262144 out
[10848.498770]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498774] ata1.00: cmd 61/00:50:cf:81:46/02:00:02:00:00/40 tag 10 cdb 0x0 
data 262144 out
[10848.498776]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498780] ata1.00: cmd 61/00:58:cf:83:46/02:00:02:00:00/40 tag 11 cdb 0x0 
data 262144 out
[10848.498781]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498786] ata1.00: cmd 61/00:60:cf:85:46/02:00:02:00:00/40 tag 12 cdb 0x0 
data 262144 out
[10848.498787]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498792] ata1.00: cmd 61/00:68:cf:87:46/04:00:02:00:00/40 tag 13 cdb 0x0 
data 524288 out
[10848.498793]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498798] ata1.00: cmd 61/00:70:cf:8b:46/04:00:02:00:00/40 tag 14 cdb 0x0 
data 524288 out
[10848.498799]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498803] ata1.00: cmd 61/00:78:cf:8f:46/02:00:02:00:00/40 tag 15 cdb 0x0 
data 262144 out
[10848.498805]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498809] ata1.00: cmd 61/00:80:cf:91:46/02:00:02:00:00/40 tag 16 cdb 0x0 
data 262144 out
[10848.498811]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498815] ata1.00: cmd 61/00:88:cf:93:46/02:00:02:00:00/40 tag 17 cdb 0x0 
data 262144 out
[10848.498816]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498821] ata1.00: cmd 61/00:90:cf:95:46/04:00:02:00:00/40 tag 18 cdb 0x0 
data 524288 out
[10848.498822]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498827] ata1.00: cmd 61/00:98:cf:99:46/02:00:02:00:00/40 tag 19 cdb 0x0 
data 262144 out
[10848.498828]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498833] ata1.00: cmd 61/00:a0:cf:9b:46/02:00:02:00:00/40 tag 20 cdb 0x0 
data 262144 out
[10848.498834]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498838] ata1.00: cmd 61/08:a8:cf:9d:46/02:00:02:00:00/40 tag 21 cdb 0x0 
data 266240 out
[10848.498840]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498844] ata1.00: cmd 61/00:b0:d7:9f:46/02:00:02:00:00/40 tag 22 cdb 0x0 
data 262144 out
[10848.498846]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498850] ata1.00: cmd 61/00:b8:d7:a1:46/02:00:02:00:00/40 tag 23 cdb 0x0 
data 262144 out
[10848.498852]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498856] ata1.00: cmd 61/00:c0:d7:a3:46/04:00:02:00:00/40 tag 24 cdb 0x0 
data 524288 out
[10848.498857]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498862] ata1.00: cmd 61/00:c8:d7:a7:46/02:00:02:00:00/40 tag 25 cdb 0x0 
data 262144 out
[10848.498863]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498868] ata1.00: cmd 61/00:d0:d7:a9:46/02:00:02:00:00/40 tag 26 cdb 0x0 
data 262144 out
[10848.498869]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498874] ata1.00: cmd 61/00:d8:d7:ab:46/02:00:02:00:00/40 tag 27 cdb 0x0 
data 262144 out
[10848.498875]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498879] ata1.00: cmd 61/00:e0:d7:ad:46/04:00:02:00:00/40 tag 28 cdb 0x0 
data 524288 out
[10848.498881]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498885] ata1.00: cmd 61/00:e8:d7:b1:46/02:00:02:00:00/40 tag 29 cdb 0x0 
data 262144 out
[10848.498886]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.498891] ata1.00: cmd 61/00:f0:d7:b3:46/02:00:02:00:00/40 tag 30 cdb 0x0 
data 262144 out
[10848.498892]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[10848.654534] ata1: soft resetting port
[10848.732492] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[10848.776308] ata1.00: Host Protected Area detected:
[10848.776309]  current size: 781422768 sectors (400 GB)
[10848.776311]  native size: -1349283664 sectors (18446743382 GB)
[10848.776317] ata1.00: configured for UDMA/66
[10848.776347] ata1: EH complete

-Christian
