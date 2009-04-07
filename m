Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbZDGGe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbZDGGe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZDGGeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:34:46 -0400
Received: from mail.charite.de ([141.42.4.200]:52489 "EHLO mail.charite.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbZDGGeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:34:46 -0400
Date: Tue, 7 Apr 2009 08:34:43 +0200
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: WATCHDOG i6300ESB doesn't reboot the machine
Message-ID: <20090407063443.GC1723@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently installed the watchdog package along with the i6300ESB
module. I killed the watchdog process and waited for the reboot. To no
avail. Is my test flawed? I even stopped the watchdog process,
unloaded and loaded the i6300esb module: No reboot. 

This is an HP-Server.

dmesg output:

[  140.017922] i6300ESB timer: initialized (0xf86cc000). heartbeat=30 sec (nowayout=0)

lspci -vv output:

00:1c.0 PCI bridge: Intel Corporation 6300ESB 64-bit PCI-X Bridge (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
        I/O behind bridge: 00004000-00004fff
        Memory behind bridge: fdf00000-fdffffff
        Prefetchable memory behind bridge: 0000000088000000-00000000880fffff
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] PCI-X bridge device
	        Secondary Status: 64bit+ 133MHz- SCD- USC- SCO- SRD- Freq=66MHz
                Status: Dev=00:1c.0 64bit+ 133MHz- SCD- USC- SCO- SRD-
                Upstream: Capacity=65535 CommitmentLimit=0
		Downstream: Capacity=65535 CommitmentLimit=0

# uname -a
Linux mail-ausfall.charite.de 2.6.29.1 #1 SMP Mon Apr 6 15:25:51 CEST 2009 i686 GNU/Linux

# cat /etc/issue
Debian GNU/Linux squeeze/sid \n \l

# lsmod |grep esb
i6300esb                4852  0 

# ll /dev/watchdog 
crw-rw---- 1 root root 10, 130  6. Apr 15:31 /dev/watchdog

-- 
Ralf Hildebrandt
  Geschäftsbereich IT | Abteilung Netzwerk
  Charité - Universitätsmedizin Berlin
  Campus Benjamin Franklin
  Hindenburgdamm 30 | D-12200 Berlin
  Tel. +49 30 450 570 155 | Fax: +49 30 450 570 962
  Ralf.Hildebrandt@charite.de | http://www.charite.de
