Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbYJERlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbYJERlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 13:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbYJERln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 13:41:43 -0400
Received: from smtp-out28.alice.it ([85.33.2.28]:2275 "EHLO
	smtp-out28.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbYJERln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 13:41:43 -0400
From: Matteo Croce <rootkit85@yahoo.it>
To: hpa@zytor.com
Subject: Machine Check Exception
Date: Sun, 5 Oct 2008 19:41:24 +0200
User-Agent: KMail/1.10.1 (Linux/2.6.27-rc8; KDE/4.1.2; x86_64; ; )
X-Face: 0AUq?,0sKh2O65+R5#[nTCS'~}"m)9|g3Tsi=g7A9q69S+=M!BY)
 =?utf-8?q?Zdmwo2u!i=5CUylx=26=27D+=0A=09=5B7u=26z1=27s=7E=5B=3F+=24=27w?=
 =?utf-8?q?O6+?="'WWcr5Jy,]}8namg8NP:9<E,o^21xGB~/HRhB(u^@
 =?utf-8?q?ZB=2EXLP0swe=0A=09r9M=7EL?=<b1=^'4cv*_N1tNJ$`9Ot*KL/;8oXFdrT@r|-Ki2wCQI"R(X(
 =?utf-8?q?73r=3A=3BmnNPoA2a=5D=7EZ=0A=092n2sUh?=,B|bt;ys*hv.QR>a]{m
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810051941.25132.rootkit85@yahoo.it>
X-OriginalArrivalTime: 05 Oct 2008 17:41:38.0688 (UTC) FILETIME=[9EADB000:01C92711]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while bugging the wireless devs about a freeze i've discovered an hardware 
bug:

HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 0 4 northbridge   Northbridge Watchdog error
       bit57 = processor context corrupt
       bit61 = error uncorrected
  bus error 'generic participation, request timed out
      generic error mem transaction
      generic access, level generic'
STATUS b200000000070f0f MCGSTATUS 4

this is triggered byt the ath9k wireless driver when booting with smp > 1
here is the kernel bug report:
http://bugzilla.kernel.org/show_bug.cgi?id=11527#c68

here I asked support in the official AMD forum:
http://forums.amd.com/forum/messageview.cfm?catid=22&threadid=101051


I ask you this as you are the "CPU ERRATA WORKAROUNDS" man,
and I CC people which are listed in the "X86 ARCHITECTURE (32-BIT AND 64-BIT)"
entry.

Best Regards,
Matteo Croce
