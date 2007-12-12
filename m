Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbXLLJY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbXLLJY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 04:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757939AbXLLJYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 04:24:49 -0500
Received: from bender.weihenstephan.org ([62.245.246.226]:58309 "EHLO
	bender.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787AbXLLJYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 04:24:48 -0500
X-Greylist: delayed 1481 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Dec 2007 04:24:48 EST
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: linux-kernel@vger.kernel.org
Subject: Re: [RFT] Port 0x80 I/O speed
Date: Wed, 12 Dec 2007 09:59:59 +0100
User-Agent: KMail/1.9.4
References: <475F1DC6.5090403@keyaccess.nl>
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712120959.59952.juergen127@kreuzholzen.de>
X-CTCH-RefID: str=0001.0A0B0205.475FA21E.02F4,ss=1,fgs=0
X-cff-SpamScore: 0(/)
X-cff-SpamReport: ----- ----- Message is unknown to the spam scanner.
X-cff-LastScanner: pcre
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ for i in `seq 5`; do ./port80; sleep 1; done
cycles: out 5260, in 2372
cycles: out 5260, in 2384
cycles: out 5260, in 2323
cycles: out 5270, in 2382
cycles: out 5259, in 2323

$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 7
model name      : Pentium III (Katmai)
stepping        : 3
cpu MHz         : 501.208
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 mmx fxsr sse
bogomips        : 993.28

#########

$ for i in `seq 5`; do ./port80; sleep 1; done
cycles: out 1214, in 1095
cycles: out 1215, in 1094
cycles: out 1214, in 1095
cycles: out 1216, in 1095
cycles: out 1213, in 1093

$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 11
model name      : Intel(R) Celeron(TM) CPU                1000MHz
stepping        : 1
cpu MHz         : 1002.285
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat 
pse36 mmx fxsr sse
bogomips        : 1998.84
