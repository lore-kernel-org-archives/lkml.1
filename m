Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbXLLVdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbXLLVdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:33:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbXLLVcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:32:54 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:49807 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbXLLVcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:32:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vNG0AmtmO63VMCM566PQr4Yd4+hXyAXWE6n722GncjneS/I4RUjYNY2dXyoEe90JZX9dy1S/cWObccTLFJPtFS6rt2BYFsbbO4JUvZg9awqHfYHwrPB+ph0YRyyKeNpYlAq2c6gxwIVL3RZjOgqI5G3aa3TWwfjMlfPgqGTEdF0=
Message-ID: <9a8748490712121332hc66c423w7c7ba353629a1004@mail.gmail.com>
Date: Wed, 12 Dec 2007 22:32:52 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: [RFT] Port 0x80 I/O speed
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz,
       andi@firstfloor.org, rol@as2917.net, "Krzysztof Halasa" <khc@pm.waw.pl>,
       david@davidnewall.com, hpa@zytor.com, john@stoffel.org,
       linux-os@analogic.com
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <475F1DC6.5090403@keyaccess.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2007, Rene Herman <rene.herman@gmail.com> wrote:
> Good day.
>
> Would some people on x86 (both 32 and 64) be kind enough to compile and run
> the attached program? This is about testing how long I/O port access to port
> 0x80 takes. It measures in CPU cycles so CPU speed is crucial in reporting.
>

root@dragon:/home/juhl# uname -a
Linux dragon 2.6.24-rc3-g2ffbb837 #7 SMP PREEMPT Mon Nov 19 22:16:27
CET 2007 i686 AMD Athlon(tm) 64 X2 Dual Core Processor 4400+
AuthenticAMD GNU/Linux
root@dragon:/home/juhl# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 35
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4400+
stepping        : 2
cpu MHz         : 2200.000
cache size      : 1024 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt lm 3dnowext 3dnow pni lahf_lm cmp_legacy ts fid vid ttp
bogomips        : 4401.67
clflush size    : 64

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 35
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4400+
stepping        : 2
cpu MHz         : 2200.000
cache size      : 1024 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt lm 3dnowext 3dnow pni lahf_lm cmp_legacy ts fid vid ttp
bogomips        : 4399.52
clflush size    : 64

root@dragon:/home/juhl# for i in $(seq 1 10); do ./port80 ; sleep 1 ; done
cycles: out 1839, in 1715
cycles: out 1728, in 1604
cycles: out 1762, in 1714
cycles: out 1770, in 1722
cycles: out 1759, in 1723
cycles: out 1764, in 1723
cycles: out 1762, in 1712
cycles: out 1761, in 1723
cycles: out 1771, in 1715
cycles: out 1770, in 1709


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
