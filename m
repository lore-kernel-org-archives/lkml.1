Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbXLLKel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbXLLKel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbXLLKee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:34:34 -0500
Received: from host86-138-52-41.range86-138.btcentralplus.com ([86.138.52.41]:40174
	"EHLO oak.selfip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbXLLKed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:34:33 -0500
Message-ID: <475FB92B.3060603@oak.selfip.net>
Date: Wed, 12 Dec 2007 10:34:19 +0000
From: Dave Haywood <tla@oak.selfip.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl>
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> Good day.
>
> Would some people on x86 (both 32 and 64) be kind enough to compile
> and run the attached program? This is about testing how long I/O port
> access to port 0x80 takes. It measures in CPU cycles so CPU speed is
> crucial in reporting.

$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 8
model name      : Pentium III (Coppermine)
stepping        : 6
cpu MHz         : 930.347
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr sse
bogomips        : 1861.99
clflush size    : 32

cycles: out 1183, in 706

cycles: out 1183, in 707

cycles: out 1182, in 706

cycles: out 1182, in 706

cycles: out 1183, in 706

cycles: out 1182, in 706

cycles: out 1182, in 706

cycles: out 1183, in 706

cycles: out 1183, in 707

cycles: out 1183, in 707

cycles: out 1183, in 706

cycles: out 1183, in 706

cycles: out 1183, in 706

cycles: out 1182, in 706

cycles: out 1183, in 707

cycles: out 1183, in 707

cycles: out 1183, in 706

cycles: out 1183, in 706

cycles: out 1182, in 706

cycles: out 1183, in 706

cycles: out 1183, in 706

cycles: out 1183, in 706

Dave.


