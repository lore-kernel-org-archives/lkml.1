Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbXIIOgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbXIIOgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 10:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbXIIOfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 10:35:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:53550 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbXIIOfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 10:35:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=S4xhTQpIJxMscSWVl9CzVNZ5pX+wzS2sey9nH0QqqVZkiRUOQNt5k5wsdl5v0oX4+junNs32OfZwnEdMgEe7rbzUsJCDBVwIQ+6lfySraz5vEhWz9ba78QXrMVnKc4uwReEgDPqMuJaoN79fEbrzt6m8HVrHayQOWcNmQ0YeMtU=
Message-ID: <46E404C3.1040908@gmail.com>
Date: Sun, 09 Sep 2007 16:35:47 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, airlied@linux.ie
Subject: Re: X freezes kernel during exit [Re: 2.6.23-rc3-mm1]
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46D17A7A.70609@gmail.com> <46D409FC.1070305@gmail.com> <46E3DCB8.5010709@gmail.com> <20070909054751.cbb27081.akpm@linux-foundation.org> <46E3FE6B.7010209@gmail.com> <20070909141730.GB25798@one.firstfloor.org> <46E4028E.9050007@gmail.com> <20070909143324.GC25798@one.firstfloor.org>
In-Reply-To: <20070909143324.GC25798@one.firstfloor.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2007 04:33 PM, Andi Kleen wrote:
> On Sun, Sep 09, 2007 at 04:26:22PM +0200, Jiri Slaby wrote:
>> BTW it is reproducible for me on two different machines (i386-x86_64,
>> radeon-intel), don't you have the problem too?
> 
> No problems here with a radeon, no.
> 
> Does your CPU have clflush or not in /proc/cpuinfo?

yes:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     E6850  @ 3.00GHz
stepping        : 11
cpu MHz         : 2992.543
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx smx est tm2
ssse3 cx16 xtpr lahf_lm
bogomips        : 5991.99
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     E6850  @ 3.00GHz
stepping        : 11
cpu MHz         : 2992.543
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx smx est tm2
ssse3 cx16 xtpr lahf_lm
bogomips        : 5985.42
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
