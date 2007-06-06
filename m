Return-Path: <linux-kernel-owner+w=401wt.eu-S1764927AbXFFOeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764927AbXFFOeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 10:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXFFOeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 10:34:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:49641 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbXFFOeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 10:34:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=FZBNJq26ntVnPAwfbUtJYzVijy9eqx80Se7VaRmjmBeguFGCZ4BorL+CvWCiU+3bEKAcAXFgLHFcc1ymY/eLahPdzDcJWHoRNAQBLMG/6r9ClV4QT+CGLhimxbdXnvbx2ZIwCxxN7ChQhDh2t153iAbGTuHquf2pjcsMuck/c0E=
Message-ID: <4666C5DC.2030505@googlemail.com>
Date: Wed, 06 Jun 2007 16:34:04 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
References: <20070606020737.4663d686.akpm@linux-foundation.org> <6bffcb0e0706060356y3628e26m49fdce4d6fb8cac9@mail.gmail.com>
In-Reply-To: <6bffcb0e0706060356y3628e26m49fdce4d6fb8cac9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski pisze:
> On 06/06/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/ 
>>
>>
> 
> It reboots immediately.

GOOD
#preserve-the-dirty-bit-in-init_page_buffers.patch
#rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty.patch
#rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty-fix.patch
#rd-simplify-by-using-the-same-helper-functions-in-libfs.patch
#rd-remove-ramdisk_set_page_dirty.patch
#rd-remove-ramdisk_set_page_dirty-fix.patch
mpu401-warning-fixes.patch
define-new-percpu-interface-for-shared-data.patch
use-the-new-percpu-interface-for-shared-data.patch
introduce-config_virt_to_bus.patch
BAD

Ok, these patches broke my P4 HT

define-new-percpu-interface-for-shared-data.patch
use-the-new-percpu-interface-for-shared-data.patch

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Pentium(R) 4 CPU 2.80GHz
stepping        : 5
cpu MHz         : 2798.721
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid xtpr
bogomips        : 5599.63
clflush size    : 64

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Pentium(R) 4 CPU 2.80GHz
stepping        : 5
cpu MHz         : 2798.721
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid xtpr
bogomips        : 5596.56
clflush size    : 64

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc4-mm1/mm-config

Regards,
Michal

-- 
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"
