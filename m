Return-Path: <linux-kernel-owner+w=401wt.eu-S1764756AbXESWwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764756AbXESWwR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761265AbXESWwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:52:09 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:56676 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757733AbXESWwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:52:08 -0400
Message-ID: <464F7F90.2000900@simon.arlott.org.uk>
Date: Sat, 19 May 2007 23:52:00 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Christian Volkmann <haveaniceday@cv-sv.de>
CC: Claas Langbehn <claas@rootdir.de>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: Via C3/C7: other flags possible ?
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <200705190753.16570.ak@suse.de> <464EE2AA.3030607@cv-sv.de> <464F332C.8060904@rootdir.de> <464F5C8F.5000304@cv-sv.de> <464F7C09.8060809@cv-sv.de>
In-Reply-To: <464F7C09.8060809@cv-sv.de>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/05/07 23:36, Christian Volkmann wrote:
> Christian Volkmann wrote:
>> Claas asked for the NX flag for the Via C3 (?) processors
>> in another thread.

If you read the other thread properly you'd see that the BIOS has 
an option to enable or disable it... when enabled it shows up.

>> I do not know another synonym for this?
>>
>> Claas Langbehn wrote:
>>> Hello Christian,
>>>
>>> do you know if and how it's possible to enable NX_bit too?
> 
> C7 Esther:
> Hmm, I expect the NX-Bit should be detected from linux during the
> boot. The NX function bit seems to be at the same place where it's
> located for other CPU.
> Unfortunately I have no C7 hardware and I am too much a beginner
> in kernel programming to prepare this "dry".
> 
> May be a "senior kernel programmer" can easy check if the C7 runs
> through the regular NX-function detection?

NX is detected ok on the C7:

processor       : 0
vendor_id       : CentaurHauls
cpu family      : 6
model           : 10
model name      : VIA Esther processor 1500MHz
stepping        : 9
cpu MHz         : 800.000
cache size      : 128 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce apic sep mtrr pge cmov pat clflush acpi mmx fxsr sse sse2 tm nx pni est tm2 rng rng_en ace ace_en ace2 ace2_en phe phe_en pmm pmm_en
bogomips        : 1601.18
clflush size    : 64

I can't reboot that box just to test cx8 detection (which is missing).

-- 
Simon Arlott
