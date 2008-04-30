Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbYD3ENQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbYD3ENQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 00:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbYD3EM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 00:12:57 -0400
Received: from hu-out-0506.google.com ([72.14.214.236]:56629 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbYD3EMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 00:12:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=i/7J3/fj/kzDu4/1aIQVE2fDJE5qN4v0UZBOb2bg1aDUWgInXwBpVLRWV8GwloWUhSW0/MnaGSiVAwwrkxd5NCxP896+UOeBruyPl6xEvZNTEMVnQGiq3IYFJyiRqvJ+SkDnGGvFxi4bgnWJULHhpsfoZA0WzDxrBja0y9kXt4k=
Message-ID: <4817F1B8.9030007@googlemail.com>
Date: Wed, 30 Apr 2008 06:12:40 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mika Fischer <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: mtrr cleanup for converting continuous to discrete
 layout v7
References: <200804272337.40130.yhlu.kernel@gmail.com>	 <48170BDB.9000801@googlemail.com>	 <86802c440804291011g1cdd2c81h962f066dd7980282@mail.gmail.com>	 <48178434.90701@googlemail.com>	 <86802c440804291449y50f178a6x4e200c26840493a@mail.gmail.com>	 <4817B5B0.5090606@googlemail.com> <4817B811.9070707@googlemail.com>	 <86802c440804291738p401e339djda18d24bce324795@mail.gmail.com>	 <4817C52A.8000000@googlemail.com>	 <86802c440804292000j1b559bc2y8281fa1608d8e4af@mail.gmail.com> <86802c440804292029y4a22e322s54220923f32f283f@mail.gmail.com>
In-Reply-To: <86802c440804292029y4a22e322s54220923f32f283f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> please try the patches
> 
> from
> http://lkml.org/lkml/2008/4/29/754
> http://lkml.org/lkml/2008/4/29/753
> 
> in addtion to
> 
> http://people.redhat.com/mingo/x86.git/README
> ( it has v8 already)
> 
> and try with mtrr_gran_size=128m

Without any value I get :

...

[    0.000000] Linux version 2.6.25-x86-latest.git-06598-g6a2c2ff-dirty (crazy@thor) (gcc version 4.3.0 (Frugalware Linux) ) #1 SMP PREEMPT Wed Apr 30 05:51:39 CEST 2008
[    0.000000] Command line: root=/dev/sdb1 ro debug vga=0x317
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
[    0.000000]  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf550000 (usable)
[    0.000000]  BIOS-e820: 00000000cf550000 - 00000000cf55e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf5e0000 - 00000000cf600000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 156) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 849232) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1228800) 2 entries of 256 used
[    0.000000] max_pfn_mapped = 1228800
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] After WB checking
[    0.000000] MTRR MAP PFN: 0000000000000000 - 000000000012c000
[    0.000000] After UC checking
[    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
[    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
[    0.000000] MTRR MAP PFN: 00000000000cf800 - 00000000000d0000
[    0.000000] After sorting
[    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
[    0.000000] MTRR MAP PFN: 00000000000cf800 - 00000000000d0000
[    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
[    0.000000] range0: 0000000000000000 - 00000000c0000000
[    0.000000] Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
[    0.000000] Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
[    0.000000] range: 00000000c0000000 - 00000000cf600000
[    0.000000] Setting variable MTRR 2, base: 3072MB, range: 128MB, type WB
[    0.000000] Setting variable MTRR 3, base: 3200MB, range: 64MB, type WB
[    0.000000] Setting variable MTRR 4, base: 3264MB, range: 32MB, type WB
[    0.000000] Setting variable MTRR 5, base: 3296MB, range: 16MB, type WB
[    0.000000] Setting variable MTRR 6, base: 3312MB, range: 4MB, type WB
[    0.000000] Setting variable MTRR 7, base: 3316MB, range: 2MB, type WB
[    0.000000] range0: 00000000cf800000 - 00000000df800000
[    0.000000] range: 00000000df800000 - 00000000d0000000
[    0.000000] DONE variable MTRRs
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] After WB checking
[    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
[    0.000000] After UC checking
[    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
[    0.000000] After sorting
[    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
[    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 704MB of RAM.
[    0.000000] update e820 for mtrr
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 000000000009cc00 (usable)
[    0.000000]  modified: 000000000009cc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000cf550000 (usable)
[    0.000000]  modified: 00000000cf550000 - 00000000cf55e000 (ACPI data)
[    0.000000]  modified: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
[    0.000000]  modified: 00000000cf5e0000 - 00000000cf600000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffc00000 - 000000012c000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 156) 3 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 849232) 3 entries of 256 used
[    0.000000] max_pfn_mapped = 1228800
[    0.000000] init_memory_mapping                                                                                                                          

...

[   20.984343] [drm] Initialized i915 1.6.0 20060119 on minor 0
[   21.450368] mtrr: no more MTRRs available

...

with mtrr_gran_size=128m I get :

...

[    0.000000] Linux version 2.6.25-x86-latest.git-06598-g6a2c2ff-dirty (crazy@thor) (gcc version 4.3.0 (Frugalware Linux) ) #1 SMP PREEMPT Wed Apr 30 05:51:39 CEST 2008
[    0.000000] Command line: root=/dev/sdb1 ro debug vga=0x317 mtrr_gran_size=128m
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
[    0.000000]  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf550000 (usable)
[    0.000000]  BIOS-e820: 00000000cf550000 - 00000000cf55e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf5e0000 - 00000000cf600000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 156) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 849232) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1228800) 2 entries of 256 used
[    0.000000] max_pfn_mapped = 1228800
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] After WB checking
[    0.000000] MTRR MAP PFN: 0000000000000000 - 000000000012c000
[    0.000000] After UC checking
[    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
[    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
[    0.000000] MTRR MAP PFN: 00000000000cf800 - 00000000000d0000
[    0.000000] After sorting
[    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
[    0.000000] MTRR MAP PFN: 00000000000cf800 - 00000000000d0000
[    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
[    0.000000] range0: 0000000000000000 - 00000000c0000000
[    0.000000] Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
[    0.000000] Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
[    0.000000] range: 00000000c0000000 - 00000000c8000000
[    0.000000] Setting variable MTRR 2, base: 3072MB, range: 128MB, type WB
[    0.000000] rangeX: 00000000d0000000 - 00000000d0000000
[    0.000000] range0: 0000000100000000 - 0000000120000000
[    0.000000] Setting variable MTRR 3, base: 4096MB, range: 512MB, type WB
[    0.000000] range: 0000000120000000 - 0000000128000000
[    0.000000] Setting variable MTRR 4, base: 4608MB, range: 128MB, type WB
[    0.000000] DONE variable MTRRs
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] After WB checking
[    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000c8000
[    0.000000] MTRR MAP PFN: 0000000000100000 - 0000000000128000
[    0.000000] After UC checking
[    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000c8000
[    0.000000] MTRR MAP PFN: 0000000000100000 - 0000000000128000
[    0.000000] After sorting
[    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000c8000
[    0.000000] MTRR MAP PFN: 0000000000100000 - 0000000000128000
[    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 181MB of RAM.
[    0.000000] update e820 for mtrr
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 000000000009cc00 (usable)
[    0.000000]  modified: 000000000009cc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000c8000000 (usable)
[    0.000000]  modified: 00000000c8000000 - 00000000cf550000 (reserved)
[    0.000000]  modified: 00000000cf550000 - 00000000cf55e000 (ACPI data)
[    0.000000]  modified: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
[    0.000000]  modified: 00000000cf5e0000 - 00000000cf600000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000128000000 (usable)
[    0.000000]  modified: 0000000128000000 - 000000012c000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 156) 3 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 819200) 3 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1212416) 3 entries of 256 used
[    0.000000] max_pfn_mapped = 1228800
[    0.000000] init_memory_mapping

...

I will try tomorrow some more boot options but now I need some sleep ;)

                                                                                                                         
> 
> Thanks
> 
> YH
> 


Gabriel
