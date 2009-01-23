Return-Path: <linux-kernel-owner+w=401wt.eu-S1761356AbZAWJ2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356AbZAWJ2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 04:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbZAWJ1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 04:27:45 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:60231 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbZAWJ1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:27:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=cKy8ZOwZe7qSP6fe9ttLhT6a/pVD7zPzSZiqhHCjCkWE8IWmTThWbzm6CcVA3ZdkCE
         oD/yCAZrYImVzzlsDG/T9rOgNTBKIlWXDbK6nr43dfuM5/PZeDXQzDOXgQoApGKHq3Cz
         f0I/1dp6tgCHAEq0ko1dZokkxtgEo+/2HCkCg=
Message-ID: <49798D8B.5050503@gmail.com>
Date: Fri, 23 Jan 2009 01:27:39 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: cat /proc/cpuinfo shows full throttle 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm confused here
when doing a cat /proc/cpuinfo
with an idle system,
I see cpu MHz at 2167.000;
should be at 1000.00
(when settled down);

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
stepping        : 6
cpu MHz         : 2167.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx est tm2 
ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
bogomips        : 4322.36
clflush size    : 64
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
stepping        : 6
cpu MHz         : 2167.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx est tm2 
ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
bogomips        : 4322.52
clflush size    : 64
power management:

the only changes to the system were
compiling xorg from git
which had me running after one dependency to the next.
(I honestly can't remember what xproto thing/whatever
package that might cause this);
any ideas would be appreciated.

In any case the system is idle and quiet.
it just says full throttle when it should say
nice and quiet.

regards;

Justin P. Mattock
