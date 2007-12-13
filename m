Return-Path: <linux-kernel-owner+w=401wt.eu-S1764441AbXLMRaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764441AbXLMRaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761130AbXLMR34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:29:56 -0500
Received: from intcomgrp.com ([216.54.13.120]:33302 "EHLO
	beta.support.intcomgrp.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761079AbXLMR3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:29:55 -0500
X-Greylist: delayed 3733 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2007 12:29:55 EST
Message-ID: <47615D81.30707@intcomgrp.com>
Date: Thu, 13 Dec 2007 11:27:45 -0500
From: James Kosin <jkosin@intcomgrp.com>
Organization: International Communications Group, Inc.
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [RFT] Port 0x80 I/O speed
References: <9zmRR-3pA-25@gated-at.bofh.it>
In-Reply-To: <9zmRR-3pA-25@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> Good day.
> 
> Would some people on x86 (both 32 and 64) be kind enough to compile and
> run the attached program? This is about testing how long I/O port access
> to port 0x80 takes. It measures in CPU cycles so CPU speed is crucial in
> reporting.
> 
> Posted a previous incarnation of this before, buried in the outb 0x80
> thread which had a serialising problem. This one should as far as I can
> see measure the right thing though. Please yell if you disagree...
> 
> For me, on a Duron 1300 (AMD756 chipset) I have a constant:
> 
> rene@7ixe4:~/src/port80$ su -c ./port80
> cycles: out 2400, in 2400
> 
> and on a PII 400 (Intel 440BX chipset) a constant:
> 
> rene@6bap:~/src/port80$ su -c ./port80
> cycles: out 553, in 251
> 
> Results are (mostly) independent of compiler optimisation, but testing
> with an -O2 compile should be most useful. Thanks!
> 
> Rene.
> 
[root@beta jkosin]# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 7
model name      : Pentium III (Katmai)
stepping        : 3
cpu MHz         : 499.156
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca
cmov pat pse36 mmx fxsr sse
bogomips        : 996.14

[root@beta jkosin]# ./a.out
cycles: out 683, in 299
[root@beta jkosin]# ./a.out
cycles: out 683, in 299
[root@beta jkosin]# ./a.out
cycles: out 683, in 299
[root@beta jkosin]#

-- 
Scanned by ClamAV - http://www.clamav.net

