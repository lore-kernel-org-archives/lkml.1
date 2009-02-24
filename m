Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbZBXDXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbZBXDXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 22:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZBXDXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 22:23:23 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:21807 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbZBXDXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 22:23:20 -0500
Date: Mon, 23 Feb 2009 19:23:04 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lenb@kernel.org" <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       mjg@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       rui.zhang@intel.com, airlied@redhat.com
Subject: Re: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not ioremap virtual address for G33 hw status page
Message-ID: <20090224032304.GA26344@hexapodia.org>
References: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com> <1235419343.4816.27.camel@gaiman> <200902232230.29501.rjw@sisk.pl> <8db1092f0902231340k7c7d0fd1me49302f2efd03491@mail.gmail.com> <86802c440902231701q1e169a67oa12bd84ac0e4c7aa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86802c440902231701q1e169a67oa12bd84ac0e4c7aa@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 05:01:10PM -0800, Yinghai Lu wrote:
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> 
> should help mtrr ones.
> 
> please post bootlog with those option set.

Doesn't help here (Dell E6400).

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.29-rc6-dirty (adi@cvp-loaner-01) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu12) ) #14 SMP Mon Feb 23 19:05:31 PST 2009
[    0.000000] Command line: root=/dev/sda1 ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007d04d400 (usable)
[    0.000000]  BIOS-e820: 000000007d04d400 - 000000007d04f400 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007d04f400 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe60000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x7d04d max_arch_pfn = 0x100000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 32GB, type WB
[    0.000000] reg 1, base: 3584MB, range: 512MB, type UC
[    0.000000] reg 2, base: 2012MB, range: 4MB, type UC
[    0.000000] reg 3, base: 2016MB, range: 32MB, type UC
[    0.000000] total RAM coverred: 32220M
[    0.000000]  gran_size: 64K 	chunk_size: 64K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 64K 	chunk_size: 128K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 64K 	chunk_size: 256K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 64K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 64K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 64K 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 64K 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 64K 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 64K 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 64K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 64K 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 64K 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 64K 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 64K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 64K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 128K 	chunk_size: 128K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 128K 	chunk_size: 256K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 128K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 128K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 128K 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 128K 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 128K 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 128K 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 128K 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 128K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 128K 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 128K 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 128K 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 128K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 128K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 256K 	chunk_size: 256K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 256K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 256K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 256K 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 256K 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 256K 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 256K 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 256K 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 256K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 256K 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 256K 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 256K 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 256K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 256K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 512K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 512K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 512K 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 512K 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 512K 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 512K 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 512K 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 512K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 512K 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 512K 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 512K 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 512K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 512K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 1M 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 1M 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 1M 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 1M 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 1M 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 1M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 1M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 1M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 1M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 1M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 1M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 1M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 2M 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 2M 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 2M 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 2M 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 2M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 2M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 2M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 2M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 2M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 2M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 2M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 4M 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 4M 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 4M 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 4M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 4M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 4M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 4M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 4M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 4M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 4M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 8M 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 8M 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 8M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 8M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 16388M
[    0.000000]  gran_size: 8M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 16388M
[    0.000000]  gran_size: 8M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16388M
[    0.000000]  gran_size: 8M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 16388M
[    0.000000]  gran_size: 8M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 16388M
[    0.000000]  gran_size: 8M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 16388M
[    0.000000]  gran_size: 16M 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 29196M
[    0.000000]  gran_size: 16M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 30220M
[    0.000000]  gran_size: 16M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 16396M
[    0.000000]  gran_size: 16M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 16396M
[    0.000000]  gran_size: 16M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16396M
[    0.000000]  gran_size: 16M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 16396M
[    0.000000]  gran_size: 16M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 16396M
[    0.000000]  gran_size: 16M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 16396M
[    0.000000]  gran_size: 32M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 28700M
[    0.000000]  gran_size: 32M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 28700M
[    0.000000]  gran_size: 32M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 32M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 32M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 32M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 32M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 64M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 28700M
[    0.000000]  gran_size: 64M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 64M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 64M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 64M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 64M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 128M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 24668M
[    0.000000]  gran_size: 128M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 92M
[    0.000000]  gran_size: 128M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 92M
[    0.000000]  gran_size: 128M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 92M
[    0.000000]  gran_size: 128M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 92M
[    0.000000]  gran_size: 256M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16604M
[    0.000000]  gran_size: 256M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 220M
[    0.000000]  gran_size: 256M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 220M
[    0.000000]  gran_size: 256M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 220M
[    0.000000]  gran_size: 512M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 476M
[    0.000000]  gran_size: 512M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 476M
[    0.000000]  gran_size: 512M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 476M
[    0.000000]  gran_size: 1G 	chunk_size: 1G 	num_reg: 5  	lose cover RAM: 1500M
[    0.000000]  gran_size: 1G 	chunk_size: 2G 	num_reg: 5  	lose cover RAM: 1500M
[    0.000000]  gran_size: 2G 	chunk_size: 2G 	num_reg: 3  	lose cover RAM: 3548M
[    0.000000] mtrr_cleanup: can not find optimal value
[    0.000000] please specify mtrr_gran_size/mtrr_chunk_size
[    0.000000] init_memory_mapping: 0000000000000000-000000007d04d000
[    0.000000]  0000000000 - 007d000000 page 2M
[    0.000000]  007d000000 - 007d04d000 page 4k
[    0.000000] kernel direct mapping tables up to 7d04d000 @ 8000-c000
[    0.000000] last_map_addr: 7d04d000 end: 7d04d000
[    0.000000] RAMDISK: 37c4b000 - 37fefdc3
[    0.000000] ACPI: RSDP 000FB9C0, 0024 (r2 DELL  )
[    0.000000] ACPI: XSDT 7D051E00, 006C (r1 DELL    M09     27D80C11 ASL        61)
[    0.000000] ACPI: FACP 7D051C9C, 00F4 (r4 DELL    M09     27D80C11 ASL        61)
[    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in Gpe0Block: 128/64 [20081204]
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT 7D052400, 6A2B (r2 INT430 SYSFexxx     1001 INTL 20050624)
[    0.000000] ACPI: FACS 7D060C00, 0040
[    0.000000] ACPI: HPET 7D051F00, 0038 (r1 DELL    M09            1 ASL        61)
[    0.000000] ACPI: ____ 7D060400, 0030 (r1 DELL    M09     27D80C11 ASL        61)
[    0.000000] ACPI: APIC 7D052000, 0068 (r1 DELL    M09     27D80C11 ASL        47)
[    0.000000] ACPI: ASF! 7D051C00, 006A (r32 DELL    M09     27D80C11 ASL        61)
[    0.000000] ACPI: MCFG 7D051FC0, 003E (r16 DELL    M09     27D80C11 ASL        61)
[    0.000000] ACPI: TCPA 7D052300, 0032 (r1                        0 ASL         0)
[    0.000000] ACPI: SLIC 7D05209C, 0176 (r1 DELL    M09     27D80C11 ASL        61)
[    0.000000] ACPI: SSDT 7D05032D, 066C (r1  PmRef    CpuPm     3000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007d04d000
[    0.000000] Bootmem setup node 0 0000000000000000-000000007d04d000
[    0.000000]   NODE_DATA [0000000000001000 - 0000000000005fff]
[    0.000000]   bootmap [000000000000a000 -  0000000000019a0f] pages 10
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 007d04d000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000bcdcd8]    TEXT DATA BSS ==> [0000200000 - 0000bcdcd8]
[    0.000000]   #3 [0037c4b000 - 0037fefdc3]          RAMDISK ==> [0037c4b000 - 0037fefdc3]
[    0.000000]   #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff880001200000-ffff880002dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007d04d
[    0.000000] On node 0 totalpages: 511980
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2611 pages reserved
[    0.000000]   DMA zone: 1332 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6946 pages used for memmap
[    0.000000]   DMA32 zone: 501035 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:78000000)
[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Allocating 69632 bytes of per cpu data
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 502367
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda1 ro
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2526.874 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Calgary: detecting Calgary via BIOS EBDA area
[    0.004000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] Memory: 2005104k/2048308k available (4737k kernel code, 388k absent, 42816k reserved, 3114k data, 640k init)
[    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 5053.74 BogoMIPS (lpj=10107496)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Initializing.
[    0.004000] SELinux:  Starting in permissive mode
[    0.004000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004172] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.004925] Mount-cache hash table entries: 256
[    0.005187] Initializing cgroup subsys ns
[    0.005301] Initializing cgroup subsys cpuacct
[    0.005432] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.005584] CPU: L2 cache: 6144K
[    0.005694] [ds] using Core 2/Atom configuration
[    0.005807] CPU 0/0x0 -> Node 0
[    0.005918] CPU: Physical Processor ID: 0
[    0.006029] CPU: Processor Core ID: 0
[    0.006140] using mwait in idle threads.
[    0.008748] ACPI: Core revision 20081204
[    0.020056] Setting APIC routing to flat
[    0.020718] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.061925] CPU0: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 06
[    0.064001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5053.98 BogoMIPS (lpj=10107964)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU 1/0x1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.149663] CPU1: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 06
[    0.150905] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.152092] Brought up 2 CPUs
[    0.152200] Total of 2 processors activated (10107.73 BogoMIPS).
[    0.152393] khelper used greatest stack depth: 5976 bytes left
[    0.152393] net_namespace: 1784 bytes
[    0.152393] Booting paravirtualized kernel on bare hardware
[    0.156131] Time:  3:08:11  Date: 02/24/09
[    0.156263] NET: Registered protocol family 16
[    0.156389] ACPI: bus type pci registered
[    0.156389] PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
[    0.156389] PCI: MCFG area at f8000000 reserved in E820
[    0.159051] PCI: Using MMCONFIG at f8000000 - fbffffff
[    0.160002] PCI: Using configuration type 1 for base access
[    0.164030] bio: create slab <bio-0> at 0
[    0.164741] ACPI: EC: Look up EC in DSDT
[    0.164938] ACPI: BIOS _OSI(Linux) query ignored
[    0.224019] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.225403] ACPI: Interpreter enabled
[    0.225403] ACPI: (supports S0 S3 S4 S5)
[    0.225403] ACPI: Using IOAPIC for interrupt routing
[    0.336125] ACPI: EC: GPE = 0x11, I/O: command/status = 0x934, data = 0x930
[    0.336175] ACPI: EC: driver started in interrupt mode
[    0.337414] ACPI: No dock devices found.
[    0.337531] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.340033] DMAR: Forcing write-buffer flush capability
[    0.340170] pci 0000:00:02.0: reg 10 64bit mmio: [0xf6c00000-0xf6ffffff]
[    0.340175] pci 0000:00:02.0: reg 18 64bit mmio: [0xe0000000-0xefffffff]
[    0.340179] pci 0000:00:02.0: reg 20 io port: [0xef98-0xef9f]
[    0.340211] pci 0000:00:02.1: reg 10 64bit mmio: [0xf6b00000-0xf6bfffff]
[    0.340315] pci 0000:00:19.0: reg 10 32bit mmio: [0xf6ae0000-0xf6afffff]
[    0.340322] pci 0000:00:19.0: reg 14 32bit mmio: [0xf6adb000-0xf6adbfff]
[    0.340329] pci 0000:00:19.0: reg 18 io port: [0xefe0-0xefff]
[    0.340383] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.340497] pci 0000:00:19.0: PME# disabled
[    0.340666] pci 0000:00:1a.0: reg 20 io port: [0x6f60-0x6f7f]
[    0.340753] pci 0000:00:1a.1: reg 20 io port: [0x6f80-0x6f9f]
[    0.340841] pci 0000:00:1a.2: reg 20 io port: [0x6fa0-0x6fbf]
[    0.340930] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfed1c400-0xfed1c7ff]
[    0.340995] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.341109] pci 0000:00:1a.7: PME# disabled
[    0.341109] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf6adc000-0xf6adffff]
[    0.341109] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.341109] pci 0000:00:1b.0: PME# disabled
[    0.341109] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.341109] pci 0000:00:1c.0: PME# disabled
[    0.341109] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.341109] pci 0000:00:1c.1: PME# disabled
[    0.341109] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.341109] pci 0000:00:1c.2: PME# disabled
[    0.341289] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.341402] pci 0000:00:1c.3: PME# disabled
[    0.341579] pci 0000:00:1d.0: reg 20 io port: [0x6f00-0x6f1f]
[    0.341666] pci 0000:00:1d.1: reg 20 io port: [0x6f20-0x6f3f]
[    0.341754] pci 0000:00:1d.2: reg 20 io port: [0x6f40-0x6f5f]
[    0.341843] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfed1c000-0xfed1c3ff]
[    0.341907] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.342020] pci 0000:00:1d.7: PME# disabled
[    0.342368] pci 0000:00:1f.2: reg 10 io port: [0x6e70-0x6e77]
[    0.342375] pci 0000:00:1f.2: reg 14 io port: [0x6e78-0x6e7b]
[    0.342382] pci 0000:00:1f.2: reg 18 io port: [0x6e80-0x6e87]
[    0.342389] pci 0000:00:1f.2: reg 1c io port: [0x6e88-0x6e8b]
[    0.342396] pci 0000:00:1f.2: reg 20 io port: [0x6ea0-0x6ebf]
[    0.342403] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfed1c800-0xfed1cfff]
[    0.342448] pci 0000:00:1f.2: PME# supported from D3hot
[    0.342559] pci 0000:00:1f.2: PME# disabled
[    0.342703] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf6adaf00-0xf6adafff]
[    0.342720] pci 0000:00:1f.3: reg 20 io port: [0x1100-0x111f]
[    0.342892] pci 0000:0c:00.0: reg 10 64bit mmio: [0xf69fe000-0xf69fffff]
[    0.343006] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    0.343121] pci 0000:0c:00.0: PME# disabled
[    0.343303] pci 0000:00:1c.1: bridge 32bit mmio: [0xf6900000-0xf69fffff]
[    0.343422] pci 0000:00:1c.3: bridge io port: [0xd000-0xdfff]
[    0.343426] pci 0000:00:1c.3: bridge 32bit mmio: [0xf6600000-0xf68fffff]
[    0.343433] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf0000000-0xf01fffff]
[    0.343476] pci 0000:03:01.0: reg 10 32bit mmio: [0xf65ff800-0xf65fffff]
[    0.343532] pci 0000:03:01.0: supports D1 D2
[    0.343533] pci 0000:03:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.343647] pci 0000:03:01.0: PME# disabled
[    0.343792] pci 0000:03:01.1: reg 10 32bit mmio: [0xf65ff600-0xf65ff6ff]
[    0.343849] pci 0000:03:01.1: supports D1 D2
[    0.343851] pci 0000:03:01.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.343965] pci 0000:03:01.1: PME# disabled
[    0.344041] pci 0000:03:01.2: reg 10 32bit mmio: [0xf65ff700-0xf65ff7ff]
[    0.344098] pci 0000:03:01.2: supports D1 D2
[    0.344100] pci 0000:03:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.344213] pci 0000:03:01.2: PME# disabled
[    0.344385] pci 0000:00:1e.0: transparent bridge
[    0.344498] pci 0000:00:1e.0: bridge 32bit mmio: [0xf6500000-0xf65fffff]
[    0.344538] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.344837] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.344949] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.345019] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.345088] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.345156] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.360662] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 *11)
[    0.360662] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *3
[    0.360662] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 *11)
[    0.360957] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 *10 11)
[    0.361433] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.362153] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.362873] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.363580] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.368027] SCSI subsystem initialized
[    0.368114] libata version 3.00 loaded.
[    0.368114] usbcore: registered new interface driver usbfs
[    0.368136] usbcore: registered new interface driver hub
[    0.368136] usbcore: registered new device driver usb
[    0.368136] PCI: Using ACPI for IRQ routing
[    0.380006] Bluetooth: Core ver 2.14
[    0.380115] NET: Registered protocol family 31
[    0.380115] Bluetooth: HCI device and connection manager initialized
[    0.380225] Bluetooth: HCI socket layer initialized
[    0.396033] cfg80211: Using static regulatory domain info
[    0.396114] cfg80211: Regulatory domain: US
[    0.396221] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.396393] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.396505] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.396616] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.396727] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.396837] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.396949] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.397060] cfg80211: Calling CRDA for country: US
[    0.400007] NetLabel: Initializing
[    0.400111] NetLabel:  domain hash size = 128
[    0.400219] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.400336] NetLabel:  unlabeled traffic allowed by default
[    0.400458] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.400458] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.423148] pnp: PnP ACPI init
[    0.423259] ACPI: bus type pnp registered
[    0.503151] Switched to high resolution mode on CPU 1
[    0.504006] Switched to high resolution mode on CPU 0
[    0.507089] pnp: PnP ACPI: found 14 devices
[    0.507197] ACPI: ACPI bus type pnp unregistered
[    0.507312] system 00:05: ioport range 0xc80-0xcaf has been reserved
[    0.507423] system 00:05: ioport range 0xcc0-0xcff could not be reserved
[    0.507537] system 00:08: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.507652] system 00:0a: ioport range 0xcb0-0xcbb has been reserved
[    0.507763] system 00:0a: iomem range 0xfed40000-0xfed44fff has been reserved
[    0.507877] system 00:0b: ioport range 0x900-0x92f has been reserved
[    0.507988] system 00:0b: ioport range 0x931-0x933 has been reserved
[    0.508098] system 00:0b: ioport range 0x935-0x97f has been reserved
[    0.508209] system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
[    0.508320] system 00:0b: ioport range 0x1000-0x1005 has been reserved
[    0.508431] system 00:0b: ioport range 0x1008-0x100f has been reserved
[    0.508546] system 00:0c: ioport range 0xf400-0xf4fe has been reserved
[    0.508657] system 00:0c: ioport range 0x1006-0x1007 has been reserved
[    0.508767] system 00:0c: ioport range 0x100a-0x1059 could not be reserved
[    0.508879] system 00:0c: ioport range 0x1060-0x107f has been reserved
[    0.508990] system 00:0c: ioport range 0x1080-0x10bf has been reserved
[    0.509106] system 00:0c: ioport range 0x1100-0x111f has been reserved
[    0.509217] system 00:0c: ioport range 0x1010-0x102f has been reserved
[    0.509328] system 00:0c: ioport range 0x809-0x809 has been reserved
[    0.509442] system 00:0d: iomem range 0x0-0x9efff could not be reserved
[    0.509553] system 00:0d: iomem range 0x9f000-0x9ffff could not be reserved
[    0.509665] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
[    0.509775] system 00:0d: iomem range 0xe0000-0xfffff has been reserved
[    0.509888] system 00:0d: iomem range 0x100000-0x7d04d3ff could not be reserved
[    0.510060] system 00:0d: iomem range 0x7d04d400-0x7dafffff could not be reserved
[    0.510232] system 00:0d: iomem range 0x7db00000-0x7dbfffff has been reserved
[    0.510343] system 00:0d: iomem range 0xffe00000-0xffffffff could not be reserved
[    0.510515] system 00:0d: iomem range 0xffa00000-0xffbfffff has been reserved
[    0.510626] system 00:0d: iomem range 0xfec00000-0xfec0ffff has been reserved
[    0.510738] system 00:0d: iomem range 0xfee00000-0xfee0ffff has been reserved
[    0.510850] system 00:0d: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.510961] system 00:0d: iomem range 0xfed45000-0xfed8ffff has been reserved
[    0.511074] system 00:0d: iomem range 0xfeda0000-0xfeda3fff has been reserved
[    0.511186] system 00:0d: iomem range 0xfeda4000-0xfeda4fff has been reserved
[    0.511297] system 00:0d: iomem range 0xfeda5000-0xfeda5fff has been reserved
[    0.511410] system 00:0d: iomem range 0xfeda6000-0xfeda6fff has been reserved
[    0.511522] system 00:0d: iomem range 0xfed1c800-0xfed1cfff has been reserved
[    0.511634] system 00:0d: iomem range 0xfed18000-0xfed1bfff has been reserved
[    0.511746] system 00:0d: iomem range 0xf8000000-0xfbffffff has been reserved
[    0.516792] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0b
[    0.516902] pci 0000:00:1c.0:   IO window: disabled
[    0.517019] pci 0000:00:1c.0:   MEM window: disabled
[    0.517129] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.517244] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:0c
[    0.517354] pci 0000:00:1c.1:   IO window: disabled
[    0.517466] pci 0000:00:1c.1:   MEM window: 0xf6900000-0xf69fffff
[    0.517578] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.517693] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:0d
[    0.517802] pci 0000:00:1c.2:   IO window: disabled
[    0.517914] pci 0000:00:1c.2:   MEM window: disabled
[    0.518024] pci 0000:00:1c.2:   PREFETCH window: disabled
[    0.518138] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:0e
[    0.518250] pci 0000:00:1c.3:   IO window: 0xd000-0xdfff
[    0.518363] pci 0000:00:1c.3:   MEM window: 0xf6600000-0xf68fffff
[    0.518476] pci 0000:00:1c.3:   PREFETCH window: 0x000000f0000000-0x000000f01fffff
[    0.520435] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
[    0.520544] pci 0000:00:1e.0:   IO window: disabled
[    0.520655] pci 0000:00:1e.0:   MEM window: 0xf6500000-0xf65fffff
[    0.520767] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.520890] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.521009] pci 0000:00:1c.0: setting latency timer to 64
[    0.521018] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.521131] pci 0000:00:1c.1: setting latency timer to 64
[    0.521139] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.521252] pci 0000:00:1c.2: setting latency timer to 64
[    0.521260] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.521373] pci 0000:00:1c.3: setting latency timer to 64
[    0.521381] pci 0000:00:1e.0: setting latency timer to 64
[    0.521384] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.521386] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.521388] pci_bus 0000:0b: resource 0 mem: [0x0-0x0]
[    0.521390] pci_bus 0000:0b: resource 1 mem: [0x0-0x0]
[    0.521391] pci_bus 0000:0b: resource 2 mem: [0x0-0x0]
[    0.521393] pci_bus 0000:0b: resource 3 mem: [0x0-0x0]
[    0.521394] pci_bus 0000:0c: resource 0 mem: [0x0-0x0]
[    0.521396] pci_bus 0000:0c: resource 1 mem: [0xf6900000-0xf69fffff]
[    0.521397] pci_bus 0000:0c: resource 2 mem: [0x0-0x0]
[    0.521399] pci_bus 0000:0c: resource 3 mem: [0x0-0x0]
[    0.521400] pci_bus 0000:0d: resource 0 mem: [0x0-0x0]
[    0.521402] pci_bus 0000:0d: resource 1 mem: [0x0-0x0]
[    0.521403] pci_bus 0000:0d: resource 2 mem: [0x0-0x0]
[    0.521405] pci_bus 0000:0d: resource 3 mem: [0x0-0x0]
[    0.521407] pci_bus 0000:0e: resource 0 io:  [0xd000-0xdfff]
[    0.521408] pci_bus 0000:0e: resource 1 mem: [0xf6600000-0xf68fffff]
[    0.521410] pci_bus 0000:0e: resource 2 mem: [0xf0000000-0xf01fffff]
[    0.521412] pci_bus 0000:0e: resource 3 mem: [0x0-0x0]
[    0.521413] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
[    0.521415] pci_bus 0000:03: resource 1 mem: [0xf6500000-0xf65fffff]
[    0.521417] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.521418] pci_bus 0000:03: resource 3 io:  [0x00-0xffff]
[    0.521420] pci_bus 0000:03: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.521441] NET: Registered protocol family 2
[    0.569083] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.569770] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.571425] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.571996] TCP: Hash tables configured (established 262144 bind 65536)
[    0.572108] TCP reno registered
[    0.581082] NET: Registered protocol family 1
[    0.581291] checking if image is initramfs... it is
[    0.841421] Freeing initrd memory: 3731k freed
[    0.842901] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.843293] audit: initializing netlink socket (disabled)
[    0.843411] type=2000 audit(1235444891.841:1): initialized
[    0.850847] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.853177] VFS: Disk quotas dquot_6.5.2
[    0.853356] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.854252] msgmni has been set to 3923
[    0.854454] SELinux:  Registering netfilter hooks
[    0.854774] alg: No test for stdrng (krng)
[    0.854977] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.855148] io scheduler noop registered
[    0.855255] io scheduler anticipatory registered
[    0.855361] io scheduler deadline registered
[    0.855568] io scheduler cfq registered (default)
[    0.855686] pci 0000:00:02.0: Boot video device
[    0.855696] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0080
[    0.855697] pci 0000:00:1a.0: Performing full reset
[    0.855716] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0080
[    0.855717] pci 0000:00:1a.1: Performing full reset
[    0.855736] pci 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0080
[    0.855737] pci 0000:00:1a.2: Performing full reset
[    0.855786] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0080
[    0.855787] pci 0000:00:1d.0: Performing full reset
[    0.855804] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0080
[    0.855806] pci 0000:00:1d.1: Performing full reset
[    0.855824] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0080
[    0.855826] pci 0000:00:1d.2: Performing full reset
[    0.855961] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.856067] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.856251] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.856323] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.856490] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.856561] pcieport-driver 0000:00:1c.2: irq 26 for MSI/MSI-X
[    0.856733] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.856804] pcieport-driver 0000:00:1c.3: irq 27 for MSI/MSI-X
[    0.857108] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.857798] ACPI: SSDT 7D050999, 0281 (r1  PmRef   BspIst     3000 INTL 20050624)
[    0.858433] ACPI: SSDT 7D050DF1, 05C6 (r1  PmRef   BspCst     3001 INTL 20050624)
[    0.858997] Monitor-Mwait will be used to enter C-1 state
[    0.859002] Monitor-Mwait will be used to enter C-2 state
[    0.859006] Monitor-Mwait will be used to enter C-3 state
[    0.859049] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.859361] processor ACPI_CPU:00: registered as cooling_device0
[    0.859471] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.860111] ACPI: SSDT 7D050C1A, 01D7 (r1  PmRef    ApIst     3000 INTL 20050624)
[    0.860676] ACPI: SSDT 7D0513B7, 008D (r1  PmRef    ApCst     3000 INTL 20050624)
[    0.861335] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.861640] processor ACPI_CPU:01: registered as cooling_device1
[    0.861750] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.884934] XENFS: not registering filesystem on non-xen platform
[    0.887429] Non-volatile memory driver v1.3
[    0.887536] Linux agpgart interface v0.103
[    0.887657] agpgart-intel 0000:00:00.0: Intel Mobile Intel® GM45 Express Chipset
[    0.889703] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    0.893465] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.893669] [drm] Initialized drm 1.1.0 20060810
[    0.893835] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.893947] pci 0000:00:02.0: setting latency timer to 64
[    0.906728] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[    0.906904] [drm] MTRR allocation failed
[    0.906904] .  Graphics performance may suffer.
[    0.907130] pci 0000:00:02.0: irq 28 for MSI/MSI-X
[    0.907143] [drm] Initialized i915 1.6.0 20080730 on minor 0
[    0.907267] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.160282] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.160768] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.162287] brd: module loaded
[    1.162457] console [netcon0] enabled
[    1.162564] netconsole: network logging started
[    1.162726] Loading iSCSI transport class v2.0-870.
[    1.163017] Driver 'sd' needs updating - please use bus_type methods
[    1.163154] Driver 'sr' needs updating - please use bus_type methods
[    1.163345] ahci 0000:00:1f.2: version 3.0
[    1.163358] ahci 0000:00:1f.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.163499] ahci 0000:00:1f.2: irq 29 for MSI/MSI-X
[    1.163556] ahci: SSS flag set, parallel bus scan disabled
[    1.163698] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[    1.163871] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems 
[    1.164053] ahci 0000:00:1f.2: setting latency timer to 64
[    1.164362] scsi0 : ahci
[    1.164601] scsi1 : ahci
[    1.164800] scsi2 : ahci
[    1.164994] scsi3 : ahci
[    1.165197] scsi4 : ahci
[    1.165401] scsi5 : ahci
[    1.166028] ata1: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1c900 irq 29
[    1.166202] ata2: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1c980 irq 29
[    1.166375] ata3: DUMMY
[    1.166479] ata4: DUMMY
[    1.166584] ata5: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1cb00 irq 29
[    1.166758] ata6: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1cb80 irq 29
[    1.648012] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.650383] ata1.00: ATA-8: ST9160414ASG, DEC5, max UDMA/133
[    1.650493] ata1.00: 312581808 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    1.653424] ata1.00: configured for UDMA/133
[    1.668092] scsi 0:0:0:0: Direct-Access     ATA      ST9160414ASG     DEC5 PQ: 0 ANSI: 5
[    1.668410] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    1.668594] sd 0:0:0:0: [sda] Write Protect is off
[    1.668702] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.668722] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.668940] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    1.669122] sd 0:0:0:0: [sda] Write Protect is off
[    1.669230] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.669250] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.669426]  sda: sda1 sda2 < sda5 >
[    1.723025] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.723213] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.204012] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.208159] ata2.00: ATAPI: HL-DT-ST DVD+/-RW GSA-U20N, A101, max UDMA/133
[    2.212968] ata2.00: configured for UDMA/133
[    2.230944] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GSA-U20N A101 PQ: 0 ANSI: 5
[    2.242192] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.242366] Uniform CD-ROM driver Revision: 3.20
[    2.242598] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.242671] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.560014] ata5: SATA link down (SStatus 0 SControl 300)
[    2.896013] ata6: SATA link down (SStatus 0 SControl 300)
[    2.912145] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.912257] ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
[    2.912279] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.912399] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    2.912402] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.912559] drivers/usb/core/inode.c: creating file 'devices'
[    2.912563] drivers/usb/core/inode.c: creating file '001'
[    2.912606] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    2.912785] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    2.912789] ehci_hcd 0000:00:1a.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    2.912803] ehci_hcd 0000:00:1a.7: reset command 000002 (park)=0 ithresh=0 period=1024 Reset HALT
[    2.916680] ehci_hcd 0000:00:1a.7: debug port 1
[    2.916792] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    2.916794] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    2.916805] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    2.916916] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    2.920791] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    2.932009] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.932148] usb usb1: default language 0x0409
[    2.932154] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.932265] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.932436] usb usb1: Product: EHCI Host Controller
[    2.932544] usb usb1: Manufacturer: Linux 2.6.29-rc6-dirty ehci_hcd
[    2.932655] usb usb1: SerialNumber: 0000:00:1a.7
[    2.932789] usb usb1: uevent
[    2.932821] usb usb1: usb_probe_device
[    2.932823] usb usb1: configuration #1 chosen from 1 choice
[    2.932936] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    2.932950] usb 1-0:1.0: uevent
[    2.932981] hub 1-0:1.0: usb_probe_interface
[    2.932983] hub 1-0:1.0: usb_probe_interface - got id
[    2.932985] hub 1-0:1.0: USB hub found
[    2.933097] hub 1-0:1.0: 6 ports detected
[    2.933203] hub 1-0:1.0: standalone hub
[    2.933204] hub 1-0:1.0: no power switching (usb 1.0)
[    2.933205] hub 1-0:1.0: individual port over-current protection
[    2.933207] hub 1-0:1.0: power on to power good time: 20ms
[    2.933211] hub 1-0:1.0: local power source is good
[    2.933213] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    2.933306] drivers/usb/core/inode.c: creating file '001'
[    2.933374] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.933494] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.933497] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.933644] drivers/usb/core/inode.c: creating file '002'
[    2.933693] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    2.933870] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    2.933874] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    2.933886] ehci_hcd 0000:00:1d.7: reset command 000002 (park)=0 ithresh=0 period=1024 Reset HALT
[    2.937768] ehci_hcd 0000:00:1d.7: debug port 1
[    2.937879] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.937881] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    2.937891] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    2.938002] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    2.941878] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    2.952006] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.952128] usb usb2: default language 0x0409
[    2.952134] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.952245] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.952417] usb usb2: Product: EHCI Host Controller
[    2.952525] usb usb2: Manufacturer: Linux 2.6.29-rc6-dirty ehci_hcd
[    2.952635] usb usb2: SerialNumber: 0000:00:1d.7
[    2.952770] usb usb2: uevent
[    2.952800] usb usb2: usb_probe_device
[    2.952802] usb usb2: configuration #1 chosen from 1 choice
[    2.952914] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    2.952926] usb 2-0:1.0: uevent
[    2.952955] hub 2-0:1.0: usb_probe_interface
[    2.952957] hub 2-0:1.0: usb_probe_interface - got id
[    2.952958] hub 2-0:1.0: USB hub found
[    2.953069] hub 2-0:1.0: 6 ports detected
[    2.953175] hub 2-0:1.0: standalone hub
[    2.953177] hub 2-0:1.0: no power switching (usb 1.0)
[    2.953178] hub 2-0:1.0: individual port over-current protection
[    2.953180] hub 2-0:1.0: power on to power good time: 20ms
[    2.953183] hub 2-0:1.0: local power source is good
[    2.953184] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    2.953246] drivers/usb/core/inode.c: creating file '001'
[    2.953326] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.953436] ohci_hcd: block sizes: ed 80 td 96
[    2.953468] uhci_hcd: USB Universal Host Controller Interface driver
[    2.953642] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.953759] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.953762] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.953907] drivers/usb/core/inode.c: creating file '003'
[    2.953950] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    2.954128] uhci_hcd 0000:00:1a.0: detected 2 ports
[    2.954240] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    2.954242] uhci_hcd 0000:00:1a.0: Performing full reset
[    2.954256] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    2.954260] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f60
[    2.954393] usb usb3: default language 0x0409
[    2.954399] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.954509] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.954680] usb usb3: Product: UHCI Host Controller
[    2.954788] usb usb3: Manufacturer: Linux 2.6.29-rc6-dirty uhci_hcd
[    2.954897] usb usb3: SerialNumber: 0000:00:1a.0
[    2.955031] usb usb3: uevent
[    2.955062] usb usb3: usb_probe_device
[    2.955063] usb usb3: configuration #1 chosen from 1 choice
[    2.955175] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    2.955192] usb 3-0:1.0: uevent
[    2.955222] hub 3-0:1.0: usb_probe_interface
[    2.955224] hub 3-0:1.0: usb_probe_interface - got id
[    2.955225] hub 3-0:1.0: USB hub found
[    2.955336] hub 3-0:1.0: 2 ports detected
[    2.955442] hub 3-0:1.0: standalone hub
[    2.955443] hub 3-0:1.0: no power switching (usb 1.0)
[    2.955445] hub 3-0:1.0: individual port over-current protection
[    2.955446] hub 3-0:1.0: power on to power good time: 2ms
[    2.955450] hub 3-0:1.0: local power source is good
[    2.955451] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    2.955499] drivers/usb/core/inode.c: creating file '001'
[    2.955567] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.955682] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    2.955685] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    2.955831] drivers/usb/core/inode.c: creating file '004'
[    2.955880] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    2.956070] uhci_hcd 0000:00:1a.1: detected 2 ports
[    2.956181] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    2.956182] uhci_hcd 0000:00:1a.1: Performing full reset
[    2.956197] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    2.956207] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f80
[    2.956340] usb usb4: default language 0x0409
[    2.956345] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.958235] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.958406] usb usb4: Product: UHCI Host Controller
[    2.958514] usb usb4: Manufacturer: Linux 2.6.29-rc6-dirty uhci_hcd
[    2.958623] usb usb4: SerialNumber: 0000:00:1a.1
[    2.958757] usb usb4: uevent
[    2.958789] usb usb4: usb_probe_device
[    2.958790] usb usb4: configuration #1 chosen from 1 choice
[    2.958902] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    2.958914] usb 4-0:1.0: uevent
[    2.958942] hub 4-0:1.0: usb_probe_interface
[    2.958944] hub 4-0:1.0: usb_probe_interface - got id
[    2.958945] hub 4-0:1.0: USB hub found
[    2.959054] hub 4-0:1.0: 2 ports detected
[    2.959161] hub 4-0:1.0: standalone hub
[    2.959162] hub 4-0:1.0: no power switching (usb 1.0)
[    2.959163] hub 4-0:1.0: individual port over-current protection
[    2.959165] hub 4-0:1.0: power on to power good time: 2ms
[    2.959168] hub 4-0:1.0: local power source is good
[    2.959169] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    2.959217] drivers/usb/core/inode.c: creating file '001'
[    2.959283] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.959397] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    2.959400] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    2.959542] drivers/usb/core/inode.c: creating file '005'
[    2.959586] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    2.959762] uhci_hcd 0000:00:1a.2: detected 2 ports
[    2.959872] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    2.959873] uhci_hcd 0000:00:1a.2: Performing full reset
[    2.959887] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    2.959891] uhci_hcd 0000:00:1a.2: irq 22, io base 0x00006fa0
[    2.960031] usb usb5: default language 0x0409
[    2.960036] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.960147] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.960317] usb usb5: Product: UHCI Host Controller
[    2.960424] usb usb5: Manufacturer: Linux 2.6.29-rc6-dirty uhci_hcd
[    2.960534] usb usb5: SerialNumber: 0000:00:1a.2
[    2.960666] usb usb5: uevent
[    2.960696] usb usb5: usb_probe_device
[    2.960698] usb usb5: configuration #1 chosen from 1 choice
[    2.960809] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    2.960822] usb 5-0:1.0: uevent
[    2.960852] hub 5-0:1.0: usb_probe_interface
[    2.960854] hub 5-0:1.0: usb_probe_interface - got id
[    2.960855] hub 5-0:1.0: USB hub found
[    2.960964] hub 5-0:1.0: 2 ports detected
[    2.961071] hub 5-0:1.0: standalone hub
[    2.961072] hub 5-0:1.0: no power switching (usb 1.0)
[    2.961073] hub 5-0:1.0: individual port over-current protection
[    2.961075] hub 5-0:1.0: power on to power good time: 2ms
[    2.961078] hub 5-0:1.0: local power source is good
[    2.961080] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    2.961128] drivers/usb/core/inode.c: creating file '001'
[    2.961197] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.961311] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.961314] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.961459] drivers/usb/core/inode.c: creating file '006'
[    2.961509] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    2.961686] uhci_hcd 0000:00:1d.0: detected 2 ports
[    2.961797] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    2.961799] uhci_hcd 0000:00:1d.0: Performing full reset
[    2.961813] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    2.961816] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f00
[    2.961953] usb usb6: default language 0x0409
[    2.961959] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.962070] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.962240] usb usb6: Product: UHCI Host Controller
[    2.962348] usb usb6: Manufacturer: Linux 2.6.29-rc6-dirty uhci_hcd
[    2.962458] usb usb6: SerialNumber: 0000:00:1d.0
[    2.962594] usb usb6: uevent
[    2.962629] usb usb6: usb_probe_device
[    2.962631] usb usb6: configuration #1 chosen from 1 choice
[    2.962742] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    2.962753] usb 6-0:1.0: uevent
[    2.962786] hub 6-0:1.0: usb_probe_interface
[    2.962787] hub 6-0:1.0: usb_probe_interface - got id
[    2.962789] hub 6-0:1.0: USB hub found
[    2.962899] hub 6-0:1.0: 2 ports detected
[    2.963006] hub 6-0:1.0: standalone hub
[    2.963007] hub 6-0:1.0: no power switching (usb 1.0)
[    2.963009] hub 6-0:1.0: individual port over-current protection
[    2.963010] hub 6-0:1.0: power on to power good time: 2ms
[    2.963013] hub 6-0:1.0: local power source is good
[    2.963015] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    2.963063] drivers/usb/core/inode.c: creating file '001'
[    2.963132] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.963248] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.963251] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.963398] drivers/usb/core/inode.c: creating file '007'
[    2.963444] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    2.963619] uhci_hcd 0000:00:1d.1: detected 2 ports
[    2.963730] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    2.963732] uhci_hcd 0000:00:1d.1: Performing full reset
[    2.963746] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    2.963750] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f20
[    2.963888] usb usb7: default language 0x0409
[    2.963893] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    2.964009] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.964180] usb usb7: Product: UHCI Host Controller
[    2.964287] usb usb7: Manufacturer: Linux 2.6.29-rc6-dirty uhci_hcd
[    2.964396] usb usb7: SerialNumber: 0000:00:1d.1
[    2.964532] usb usb7: uevent
[    2.964565] usb usb7: usb_probe_device
[    2.964566] usb usb7: configuration #1 chosen from 1 choice
[    2.964678] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    2.964689] usb 7-0:1.0: uevent
[    2.964722] hub 7-0:1.0: usb_probe_interface
[    2.964723] hub 7-0:1.0: usb_probe_interface - got id
[    2.964725] hub 7-0:1.0: USB hub found
[    2.964835] hub 7-0:1.0: 2 ports detected
[    2.964941] hub 7-0:1.0: standalone hub
[    2.964943] hub 7-0:1.0: no power switching (usb 1.0)
[    2.964944] hub 7-0:1.0: individual port over-current protection
[    2.964946] hub 7-0:1.0: power on to power good time: 2ms
[    2.964949] hub 7-0:1.0: local power source is good
[    2.964950] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    2.965001] drivers/usb/core/inode.c: creating file '001'
[    2.965070] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.965185] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.965188] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.965338] drivers/usb/core/inode.c: creating file '008'
[    2.965382] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    2.965559] uhci_hcd 0000:00:1d.2: detected 2 ports
[    2.965669] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    2.965671] uhci_hcd 0000:00:1d.2: Performing full reset
[    2.965685] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    2.965689] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    2.965827] usb usb8: default language 0x0409
[    2.965832] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    2.965943] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.966115] usb usb8: Product: UHCI Host Controller
[    2.966221] usb usb8: Manufacturer: Linux 2.6.29-rc6-dirty uhci_hcd
[    2.966330] usb usb8: SerialNumber: 0000:00:1d.2
[    2.966465] usb usb8: uevent
[    2.966498] usb usb8: usb_probe_device
[    2.966500] usb usb8: configuration #1 chosen from 1 choice
[    2.966609] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    2.966621] usb 8-0:1.0: uevent
[    2.966653] hub 8-0:1.0: usb_probe_interface
[    2.966654] hub 8-0:1.0: usb_probe_interface - got id
[    2.966656] hub 8-0:1.0: USB hub found
[    2.966764] hub 8-0:1.0: 2 ports detected
[    2.966870] hub 8-0:1.0: standalone hub
[    2.966871] hub 8-0:1.0: no power switching (usb 1.0)
[    2.966872] hub 8-0:1.0: individual port over-current protection
[    2.966874] hub 8-0:1.0: power on to power good time: 2ms
[    2.966877] hub 8-0:1.0: local power source is good
[    2.966878] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    2.966931] drivers/usb/core/inode.c: creating file '001'
[    2.967064] usbcore: registered new interface driver usblp
[    2.967174] Initializing USB Mass Storage driver...
[    2.967333] usbcore: registered new interface driver usb-storage
[    2.967442] USB Mass Storage support registered.
[    2.967601] usbcore: registered new interface driver libusual
[    2.967795] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.968262] i8042.c: Warning: Keylock active.
[    2.972189] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.972300] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.972463] mice: PS/2 mouse device common for all mice
[    2.972707] rtc_cmos 00:03: RTC can wake from S4
[    2.972865] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.973000] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.973161] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.973573] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    2.974001] cpuidle: using governor ladder
[    2.974567] cpuidle: using governor menu
[    2.974690] No iBFT detected.
[    2.974815] Marking TSC unstable due to TSC halts in idle
[    2.975020] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    2.975939] usbcore: registered new interface driver hiddev
[    2.976095] usbcore: registered new interface driver usbhid
[    2.976205] usbhid: v2.6:USB HID core driver
[    2.976358] Advanced Linux Sound Architecture Driver Version 1.0.18a.
[    2.978435] modprobe used greatest stack depth: 5312 bytes left
[    2.978996] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    2.979019] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    3.032071] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
[    3.032076] hub 1-0:1.0: port 1: status 0501 change 0001
[    3.032094] ehci_hcd 0000:00:1a.7: GetStatus port 5 status 001803 POWER sig=j CSC CONNECT
[    3.032098] hub 1-0:1.0: port 5: status 0501 change 0001
[    3.032107] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 001803 POWER sig=j CSC CONNECT
[    3.032111] hub 1-0:1.0: port 6: status 0501 change 0001
[    3.052068] uhci_hcd 0000:00:1a.0: port 1 portsc 0082,00
[    3.052083] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    3.056061] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.060048] uhci_hcd 0000:00:1a.2: port 1 portsc 008a,00
[    3.060065] uhci_hcd 0000:00:1a.2: port 2 portsc 0082,00
[    3.060086] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.064071] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.064075] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.088489] input: HDA Intel Mic at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/input/input1
[    3.100340] input: HDA Intel Mic at Ext Right Jack as /devices/pci0000:00/0000:00:1b.0/input/input2
[    3.116336] input: HDA Intel Line Out at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/input/input3
[    3.132056] hub 1-0:1.0: state 7 ports 6 chg 0062 evt 0000
[    3.132063] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    3.132363] input: HDA Intel HP Out at Ext Right Jack as /devices/pci0000:00/0000:00:1b.0/input/input4
[    3.149280] ALSA device list:
[    3.149386]   #0: HDA Intel at 0xf6adc000 irq 21
[    3.149534] Netfilter messages via NETLINK v0.30.
[    3.149651] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.150003] ctnetlink v0.93: registering with nfnetlink.
[    3.150608] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.150743] TCP cubic registered
[    3.150849] Initializing XFRM netlink socket
[    3.151263] NET: Registered protocol family 10
[    3.152024] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    3.152175] IPv6 over IPv4 tunneling driver
[    3.152795] NET: Registered protocol family 17
[    3.153156] RPC: Registered udp transport module.
[    3.153264] RPC: Registered tcp transport module.
[    3.153380] lib80211: common routines for IEEE802.11 drivers
[    3.153489] lib80211_crypt: registered algorithm 'NULL'
[    3.154514] registered taskstats version 1
[    3.154735]   Magic number: 13:158:109
[    3.154845] usbmon usbmon5: hash matches
[    3.155044] Freeing unused kernel memory: 640k freed
[    3.155392] Write protecting the kernel read-only data: 7016k
[    3.161844] all_generic_ide used greatest stack depth: 5296 bytes left
[    3.189944] ehci_hcd 0000:00:1a.7: port 1 high speed
[    3.189948] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[    3.244050] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    3.267329] thermal LNXTHERM:01: registered as thermal_zone0
[    3.274349] ACPI: Thermal Zone [THM] (43 C)
[    3.294905] usb usb3: uevent
[    3.294920] usb 3-0:1.0: uevent
[    3.294997] usb usb4: uevent
[    3.295012] usb 4-0:1.0: uevent
[    3.295090] usb usb5: uevent
[    3.295104] usb 5-0:1.0: uevent
[    3.295180] usb usb1: uevent
[    3.295195] usb 1-0:1.0: uevent
[    3.295768] usb usb6: uevent
[    3.295783] usb 6-0:1.0: uevent
[    3.295859] usb usb7: uevent
[    3.295874] usb 7-0:1.0: uevent
[    3.295953] usb usb8: uevent
[    3.295968] usb 8-0:1.0: uevent
[    3.296043] usb usb2: uevent
[    3.296057] usb 2-0:1.0: uevent
[    3.300324] ehci_hcd 0000:00:1a.7: port 1 high speed
[    3.300328] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[    3.376456] usb 1-1: New USB device found, idVendor=0424, idProduct=2512
[    3.376569] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.376733] usb 1-1: uevent
[    3.376745] usb 1-1: usb_probe_device
[    3.376747] usb 1-1: configuration #1 chosen from 1 choice
[    3.376952] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    3.376965] usb 1-1:1.0: uevent
[    3.376975] hub 1-1:1.0: usb_probe_interface
[    3.376976] hub 1-1:1.0: usb_probe_interface - got id
[    3.376978] hub 1-1:1.0: USB hub found
[    3.377203] hub 1-1:1.0: 2 ports detected
[    3.377312] hub 1-1:1.0: compound device; port removable status: FF
[    3.377313] hub 1-1:1.0: individual port power switching
[    3.377315] hub 1-1:1.0: individual port over-current protection
[    3.377316] hub 1-1:1.0: Single TT
[    3.377317] hub 1-1:1.0: TT requires at most 8 FS bit times (666 ns)
[    3.377319] hub 1-1:1.0: power on to power good time: 100ms
[    3.377577] hub 1-1:1.0: local power source is good
[    3.377579] hub 1-1:1.0: enabling power on all ports
[    3.377863] drivers/usb/core/inode.c: creating file '002'
[    3.377897] hub 1-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
[    3.381794] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    3.381920] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    3.382141] e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    3.382259] e1000e 0000:00:19.0: setting latency timer to 64
[    3.382390] e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
[    3.433195] ehci_hcd 0000:00:1a.7: port 5 full speed --> companion
[    3.433200] ehci_hcd 0000:00:1a.7: GetStatus port 5 status 003801 POWER OWNER sig=j CONNECT
[    3.433203] hub 1-0:1.0: port 5 not reset yet, waiting 50ms
[    3.470758] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:21:70:d1:b7:92
[    3.470932] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.471067] 0000:00:19.0: eth0: MAC: 6, PHY: 8, PBA No: 1004ff-0ff
[    3.471189] ohci1394 0000:03:01.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.477081] hub 1-1:1.0: port 1: status 0101 change 0001
[    3.477328] hub 1-1:1.0: port 2: status 0101 change 0001
[    3.489018] ehci_hcd 0000:00:1a.7: GetStatus port 5 status 003002 POWER OWNER sig=se0 CSC
[    3.489040] hub 1-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[    3.500010] Clocksource tsc unstable (delta = -107835430 ns)
[    3.530036] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[f65ff800-f65fffff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[    3.545321] ehci_hcd 0000:00:1a.7: port 6 high speed
[    3.545325] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 001005 POWER sig=se0 PE CONNECT
[    3.577021] usb 1-1: link qh256-0001/ffff88007a9f4140 start 255 [1/0 us]
[    3.601047] usb 1-6: new high speed USB device using ehci_hcd and address 4
[    3.657321] ehci_hcd 0000:00:1a.7: port 6 high speed
[    3.657324] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 001005 POWER sig=se0 PE CONNECT
[    3.684507] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input5
[    3.725073] PM: Starting manual resume from disk
[    3.725181] PM: Resume from partition 8:5
[    3.725182] PM: Checking hibernation image.
[    3.725680] PM: Resume from disk failed.
[    3.730659] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input6
[    3.769115] usb 1-6: skipped 2 descriptors after configuration
[    3.769119] usb 1-6: skipped 6 descriptors after interface
[    3.769122] usb 1-6: skipped 1 descriptor after endpoint
[    3.769124] usb 1-6: skipped 8 descriptors after interface
[    3.769736] usb 1-6: default language 0x0409
[    3.774733] usb 1-6: New USB device found, idVendor=0c45, idProduct=63f8
[    3.776634] usb 1-6: New USB device strings: Mfr=2, Product=1, SerialNumber=0
[    3.776744] usb 1-6: Product: Laptop_Integrated_Webcam_0.3M
[    3.776852] usb 1-6: Manufacturer: CN0TX593724878C2013V
[    3.776992] usb 1-6: uevent
[    3.777468] usb 1-6: usb_probe_device
[    3.777470] usb 1-6: configuration #1 chosen from 1 choice
[    3.777995] usb 1-6: adding 1-6:1.0 (config #1, interface 0)
[    3.779988] usb 1-6:1.0: uevent
[    3.780052] usb 1-6: adding 1-6:1.1 (config #1, interface 1)
[    3.780076] usb 1-6:1.1: uevent
[    3.780096] drivers/usb/core/inode.c: creating file '004'
[    3.780144] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.780151] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    3.780160] uhci_hcd 0000:00:1a.2: port 1 portsc 0093,00
[    3.780169] hub 5-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    3.785317] kjournald starting.  Commit interval 5 seconds
[    3.785360] EXT3-fs: mounted filesystem with ordered data mode.
[    3.794907] udevd used greatest stack depth: 4912 bytes left
[    3.909058] hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    4.021054] usb 5-1: new full speed USB device using uhci_hcd and address 2
[    4.124053] usb usb4: suspend_rh (auto-stop)
[    4.124081] usb usb6: suspend_rh (auto-stop)
[    4.124107] usb usb7: suspend_rh (auto-stop)
[    4.124133] usb usb8: suspend_rh (auto-stop)
[    4.174074] usb 5-1: skipped 1 descriptor after interface
[    4.174078] usb 5-1: skipped 1 descriptor after interface
[    4.181046] usb 5-1: default language 0x0409
[    4.200074] usb 5-1: New USB device found, idVendor=0a5c, idProduct=5800
[    4.200189] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.200307] usb 5-1: Product: 5880
[    4.200410] usb 5-1: Manufacturer: Broadcom Corp
[    4.200515] usb 5-1: SerialNumber: 0123456789ABCD
[    4.200654] usb 5-1: uevent
[    4.200664] usb 5-1: usb_probe_device
[    4.200665] usb 5-1: configuration #0 chosen from 1 choice
[    4.200772] usb 5-1: config 0 descriptor??
[    4.202077] usb 5-1: adding 5-1:0.0 (config #0, interface 0)
[    4.207080] usb 5-1:0.0: uevent
[    4.207195] usb 5-1: adding 5-1:0.1 (config #0, interface 1)
[    4.210078] usb 5-1:0.1: uevent
[    4.210190] drivers/usb/core/inode.c: creating file '002'
[    4.210231] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0020
[    4.210240] hub 1-1:1.0: state 7 ports 2 chg 0006 evt 0000
[    4.210379] hub 1-1:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    4.224239] hub 1-1:1.0: port 1 not reset yet, waiting 10ms
[    4.296246] usb 1-1.1: new high speed USB device using ehci_hcd and address 5
[    4.323901] runlevel used greatest stack depth: 3608 bytes left
[    4.368054] usb usb3: suspend_rh (auto-stop)
[    4.388484] usb 1-1.1: skipped 2 descriptors after interface
[    4.388488] usb 1-1.1: New USB device found, idVendor=413c, idProduct=8149
[    4.388605] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.388813] usb 1-1.1: uevent
[    4.388820] usb 1-1.1: usb_probe_device
[    4.388822] usb 1-1.1: configuration #1 chosen from 1 choice
[    4.389108] usb 1-1.1: adding 1-1.1:1.0 (config #1, interface 0)
[    4.389128] usb 1-1.1:1.0: uevent
[    4.389148] drivers/usb/core/inode.c: creating file '005'
[    4.389359] hub 1-1:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    4.404239] hub 1-1:1.0: port 2 not reset yet, waiting 10ms
[    4.477239] usb 1-1.2: new full speed USB device using ehci_hcd and address 6
[    4.573046] usb 1-1.2: ep0 maxpacket = 8
[    4.574585] usb 1-1.2: default language 0x0409
[    4.574968] usb 1-1.2: New USB device found, idVendor=0a5c, idProduct=4500
[    4.575085] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.575263] usb 1-1.2: Product: BCM2046B1
[    4.575368] usb 1-1.2: Manufacturer: Broadcom
[    4.575502] usb 1-1.2: uevent
[    4.575510] usb 1-1.2: usb_probe_device
[    4.575512] usb 1-1.2: configuration #1 chosen from 1 choice
[    4.575719] usb 1-1.2: adding 1-1.2:1.0 (config #1, interface 0)
[    4.575742] usb 1-1.2:1.0: uevent
[    4.575758] hub 1-1.2:1.0: usb_probe_interface
[    4.575760] hub 1-1.2:1.0: usb_probe_interface - got id
[    4.575763] hub 1-1.2:1.0: USB hub found
[    4.575968] hub 1-1.2:1.0: 3 ports detected
[    4.576110] hub 1-1.2:1.0: compound device; port removable status: FFF
[    4.576112] hub 1-1.2:1.0: ganged power switching
[    4.576113] hub 1-1.2:1.0: global over-current protection
[    4.576114] hub 1-1.2:1.0: power on to power good time: 100ms
[    4.576359] hub 1-1.2:1.0: local power source is good
[    4.576361] hub 1-1.2:1.0: no over-current condition exists
[    4.576364] hub 1-1.2:1.0: enabling power on all ports
[    4.576756] drivers/usb/core/inode.c: creating file '006'
[    4.576797] hub 1-1:1.0: state 7 ports 2 chg 0000 evt 0004
[    4.647200] mount used greatest stack depth: 3520 bytes left
[    4.677261] hub 1-1.2:1.0: port 1: status 0101 change 0001
[    4.677495] hub 1-1.2:1.0: port 2: status 0101 change 0001
[    4.777056] usb 1-1.2: link qh128-0601/ffff88007a9f43c0 start 127 [1/2 us]
[    4.777065] hub 1-1.2:1.0: state 7 ports 3 chg 0006 evt 0000
[    4.777216] hub 1-1.2:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    4.805412] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[314fc00010e571e1]
[    4.849239] usb 1-1.2.1: new full speed USB device using ehci_hcd and address 7
[    4.941056] usb 1-1.2.1: ep0 maxpacket = 8
[    4.943970] usb 1-1.2.1: skipped 1 descriptor after interface
[    4.943974] usb 1-1.2.1: New USB device found, idVendor=413c, idProduct=8153
[    4.944115] usb 1-1.2.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.944329] usb 1-1.2.1: uevent
[    4.944338] usb 1-1.2.1: usb_probe_device
[    4.944340] usb 1-1.2.1: configuration #1 chosen from 1 choice
[    4.944613] usb 1-1.2.1: adding 1-1.2.1:1.0 (config #1, interface 0)
[    4.944634] usb 1-1.2.1:1.0: uevent
[    4.944656] usbhid 1-1.2.1:1.0: usb_probe_interface
[    4.944659] usbhid 1-1.2.1:1.0: usb_probe_interface - got id
[    4.946224] input: HID 413c:8153 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2.1/1-1.2.1:1.0/input/input7
[    4.965070] usb 1-1.2.1: link qh8-3008/ffff88007a9f4500 start 7 [1/2 us]
[    4.981092] generic-usb 0003:413C:8153.0001: input,hidraw0: USB HID v1.11 Keyboard [HID 413c:8153] on usb-0000:00:1a.7-1.2.1/input0
[    4.981384] drivers/usb/core/inode.c: creating file '007'
[    4.981620] hub 1-1.2:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    5.052250] usb 1-1.2.2: new full speed USB device using ehci_hcd and address 8
[    5.145047] usb 1-1.2.2: ep0 maxpacket = 8
[    5.148616] usb 1-1.2.2: skipped 1 descriptor after interface
[    5.148620] usb 1-1.2.2: skipped 1 descriptor after endpoint
[    5.148623] usb 1-1.2.2: New USB device found, idVendor=413c, idProduct=8154
[    5.148739] usb 1-1.2.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.148952] usb 1-1.2.2: uevent
[    5.148959] usb 1-1.2.2: usb_probe_device
[    5.148961] usb 1-1.2.2: configuration #1 chosen from 1 choice
[    5.149238] usb 1-1.2.2: adding 1-1.2.2:1.0 (config #1, interface 0)
[    5.149262] usb 1-1.2.2:1.0: uevent
[    5.149283] usbhid 1-1.2.2:1.0: usb_probe_interface
[    5.149286] usbhid 1-1.2.2:1.0: usb_probe_interface - got id
[    5.152009] input: HID 413c:8154 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2.2/1-1.2.2:1.0/input/input8
[    5.184100] generic-usb 0003:413C:8154.0002: input,hidraw1: USB HID v1.11 Mouse [HID 413c:8154] on usb-0000:00:1a.7-1.2.2/input0
[    5.184310] drivers/usb/core/inode.c: creating file '008'
[    5.184336] hub 1-1.2:1.0: state 7 ports 3 chg 0000 evt 0004
[    5.805050] hub 3-0:1.0: hub_suspend
[    5.805056] usb usb3: bus auto-suspend
[    5.805058] usb usb3: suspend_rh
[    5.816054] hub 2-0:1.0: hub_suspend
[    5.816059] usb usb2: bus auto-suspend
[    5.816062] ehci_hcd 0000:00:1d.7: suspend root hub
[    5.816085] hub 4-0:1.0: hub_suspend
[    5.816088] usb usb4: bus auto-suspend
[    5.816091] usb usb4: suspend_rh
[    5.816107] hub 6-0:1.0: hub_suspend
[    5.816110] usb usb6: bus auto-suspend
[    5.816112] usb usb6: suspend_rh
[    5.816128] hub 7-0:1.0: hub_suspend
[    5.816132] usb usb7: bus auto-suspend
[    5.816134] usb usb7: suspend_rh
[    5.816150] hub 8-0:1.0: hub_suspend
[    5.816153] usb usb8: bus auto-suspend
[    5.816155] usb usb8: suspend_rh
[    8.523772] udevd version 124 started
[    8.581907] usb usb3: uevent
[    8.581925] usb 3-0:1.0: uevent
[    8.582017] usb usb4: uevent
[    8.582034] usb 4-0:1.0: uevent
[    8.582124] usb usb5: uevent
[    8.582142] usb 5-0:1.0: uevent
[    8.582176] usb 5-1: uevent
[    8.582194] usb 5-1:0.0: uevent
[    8.582260] usb 5-1:0.1: uevent
[    8.582398] usb usb1: uevent
[    8.582415] usb 1-0:1.0: uevent
[    8.582449] usb 1-1: uevent
[    8.582466] usb 1-1.1: uevent
[    8.582485] usb 1-1.1:1.0: uevent
[    8.582521] usb 1-1.2: uevent
[    8.582539] usb 1-1.2.1: uevent
[    8.582558] usb 1-1.2.1:1.0: uevent
[    8.582695] usb 1-1.2.2: uevent
[    8.582715] usb 1-1.2.2:1.0: uevent
[    8.582865] usb 1-1.2:1.0: uevent
[    8.582918] usb 1-1:1.0: uevent
[    8.582968] usb 1-6: uevent
[    8.582985] usb 1-6:1.0: uevent
[    8.583021] usb 1-6:1.1: uevent
[    8.583707] usb usb6: uevent
[    8.583726] usb 6-0:1.0: uevent
[    8.583817] usb usb7: uevent
[    8.583835] usb 7-0:1.0: uevent
[    8.583926] usb usb8: uevent
[    8.583944] usb 8-0:1.0: uevent
[    8.584038] usb usb2: uevent
[    8.584056] usb 2-0:1.0: uevent
[    8.647860] ACPI: AC Adapter [AC] (on-line)
[    8.656923] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input9
[    8.668955] ACPI: Lid Switch [LID]
[    8.703693] ACPI: Battery Slot [BAT0] (battery present)
[    8.703860] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input10
[    8.728077] ACPI: Power Button (CM) [PBTN]
[    8.728246] ACPI: Battery Slot [BAT1] (battery absent)
[    8.728410] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input11
[    8.752075] ACPI: Sleep Button (CM) [SBTN]
[    8.775649] usb usb2: usb auto-resume
[    8.775653] ehci_hcd 0000:00:1d.7: resume root hub
[    8.801033] hub 2-0:1.0: hub_resume
[    8.801107] usb usb8: usb auto-resume
[    8.801110] usb usb8: wakeup_rh
[    8.801117] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    8.841016] hub 8-0:1.0: hub_resume
[    8.841080] usb usb7: usb auto-resume
[    8.841082] usb usb7: wakeup_rh
[    8.841088] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.881013] hub 7-0:1.0: hub_resume
[    8.881077] usb usb6: usb auto-resume
[    8.881080] usb usb6: wakeup_rh
[    8.881087] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.921015] hub 6-0:1.0: hub_resume
[    8.921293] usb usb4: usb auto-resume
[    8.921295] usb usb4: wakeup_rh
[    8.921303] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.961014] hub 4-0:1.0: hub_resume
[    8.961073] usb usb3: usb auto-resume
[    8.961075] usb usb3: wakeup_rh
[    8.961081] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    9.001047] hub 3-0:1.0: hub_resume
[    9.001149] usbhid 1-1.2.2:1.0: disconnect by usbfs
[    9.001242] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    9.029191] usb 1-1.2.2: usbfs: process 2074 (hid2hci) did not claim interface 0 before use
[    9.064116] hub 1-1.2:1.0: state 7 ports 3 chg 0000 evt 0008
[    9.064485] hub 1-1.2:1.0: port 3, status 0101, change 0001, 12 Mb/s
[    9.193257] hub 1-1.2:1.0: debounce: port 3: total 100ms stable 100ms status 0x101
[    9.265248] usb 1-1.2.3: new full speed USB device using ehci_hcd and address 9
[    9.359746] usb 1-1.2.3: skipped 1 descriptor after interface
[    9.359999] usb 1-1.2.3: default language 0x0409
[    9.360873] usb 1-1.2.3: New USB device found, idVendor=413c, idProduct=8152
[    9.361321] usb 1-1.2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    9.362084] usb 1-1.2.3: Product: Dell Wireless 410 Bluetooth + UWB Mini-card
[    9.362531] usb 1-1.2.3: Manufacturer: Dell Computer Corp
[    9.363027] usb 1-1.2.3: uevent
[    9.363042] usb 1-1.2.3: usb_probe_device
[    9.363044] usb 1-1.2.3: configuration #1 chosen from 1 choice
[    9.363360] usb 1-1.2.3: adding 1-1.2.3:1.0 (config #1, interface 0)
[    9.363374] usb 1-1.2.3:1.0: uevent
[    9.363463] usb 1-1.2.3: adding 1-1.2.3:1.1 (config #1, interface 1)
[    9.363475] usb 1-1.2.3:1.1: uevent
[    9.363531] usb 1-1.2.3: adding 1-1.2.3:1.2 (config #1, interface 2)
[    9.363544] usb 1-1.2.3:1.2: uevent
[    9.363600] usb 1-1.2.3: adding 1-1.2.3:1.3 (config #1, interface 3)
[    9.363612] usb 1-1.2.3:1.3: uevent
[    9.363625] drivers/usb/core/inode.c: creating file '009'
[    9.363657] hub 1-1.2:1.0: state 7 ports 3 chg 0000 evt 0008
[    9.416864] Bluetooth: Generic Bluetooth USB driver ver 0.4
[    9.416999] btusb 1-1.2.3:1.0: usb_probe_interface
[    9.417001] btusb 1-1.2.3:1.0: usb_probe_interface - got id
[    9.417040] btusb 1-1.2.3:1.2: usb_probe_interface
[    9.417041] btusb 1-1.2.3:1.2: usb_probe_interface - got id
[    9.417048] btusb 1-1.2.3:1.3: usb_probe_interface
[    9.417050] btusb 1-1.2.3:1.3: usb_probe_interface - got id
[    9.417060] usbcore: registered new interface driver btusb
[    9.530937] Adding 5879748k swap on /dev/sda5.  Priority:-1 extents:1 across:5879748k 
[    9.829686] EXT3 FS on sda1, internal journal
[   10.073058] usb usb8: suspend_rh (auto-stop)
[   10.073086] usb usb7: suspend_rh (auto-stop)
[   10.073113] usb usb6: suspend_rh (auto-stop)
[   10.073139] usb usb4: suspend_rh (auto-stop)
[   10.073165] usb usb3: suspend_rh (auto-stop)
[   10.805617] hub 2-0:1.0: hub_suspend
[   10.805624] usb usb2: bus auto-suspend
[   10.805625] ehci_hcd 0000:00:1d.7: suspend root hub
[   11.657756] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   11.804061] hub 8-0:1.0: hub_suspend
[   11.804071] usb usb8: bus auto-suspend
[   11.804073] usb usb8: suspend_rh
[   11.804091] hub 7-0:1.0: hub_suspend
[   11.804094] usb usb7: bus auto-suspend
[   11.804097] usb usb7: suspend_rh
[   11.804113] hub 6-0:1.0: hub_suspend
[   11.804117] usb usb6: bus auto-suspend
[   11.804119] usb usb6: suspend_rh
[   11.804135] hub 4-0:1.0: hub_suspend
[   11.804139] usb usb4: bus auto-suspend
[   11.804141] usb usb4: suspend_rh
[   11.804156] hub 3-0:1.0: hub_suspend
[   11.804160] usb usb3: bus auto-suspend
[   11.804162] usb usb3: suspend_rh
[   12.423826] ppdev: user-space parallel port driver
[   14.091858] usb usb2: usb auto-resume
[   14.091868] ehci_hcd 0000:00:1d.7: resume root hub
[   14.117259] hub 2-0:1.0: hub_resume
[   14.117525] usb usb8: usb auto-resume
[   14.117533] usb usb8: wakeup_rh
[   14.117553] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   14.151772] Bluetooth: L2CAP ver 2.11
[   14.151779] Bluetooth: L2CAP socket layer initialized
[   14.157063] hub 8-0:1.0: hub_resume
[   14.157229] usb usb7: usb auto-resume
[   14.157235] usb usb7: wakeup_rh
[   14.157251] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.176221] Bluetooth: SCO (Voice Link) ver 0.6
[   14.176227] Bluetooth: SCO socket layer initialized
[   14.197266] hub 7-0:1.0: hub_resume
[   14.197496] usb usb6: usb auto-resume
[   14.197504] usb usb6: wakeup_rh
[   14.197524] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.202484] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   14.212744] btusb_submit_intr_urb: hci0 urb ffff88007788c6c0 submission failed (28)
[   14.237256] hub 6-0:1.0: hub_resume
[   14.238317] usb usb4: usb auto-resume
[   14.238324] usb usb4: wakeup_rh
[   14.238346] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.276269] hub 4-0:1.0: hub_resume
[   14.276484] usb usb3: usb auto-resume
[   14.276491] usb usb3: wakeup_rh
[   14.276510] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.316076] hub 3-0:1.0: hub_resume
[   14.316406] usbfs 1-1.2.2:1.0: disconnect by usbfs
[   14.316430] usb 1-1.2.2: usbfs: process 3749 (hid2hci) did not claim interface 0 before use
[   14.316468] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.343621] Bluetooth: RFCOMM socket layer initialized
[   14.343628] Bluetooth: RFCOMM ver 1.10
[   15.281037] usb usb8: suspend_rh (auto-stop)
[   15.281075] usb usb7: suspend_rh (auto-stop)
[   15.281107] usb usb6: suspend_rh (auto-stop)
[   15.281137] usb usb4: suspend_rh (auto-stop)
[   15.529027] usb usb3: suspend_rh (auto-stop)
[   16.805016] hub 2-0:1.0: hub_suspend
[   16.805023] usb usb2: bus auto-suspend
[   16.805025] ehci_hcd 0000:00:1d.7: suspend root hub
[   16.805047] hub 8-0:1.0: hub_suspend
[   16.805049] usb usb8: bus auto-suspend
[   16.805051] usb usb8: suspend_rh
[   16.805065] hub 7-0:1.0: hub_suspend
[   16.805067] usb usb7: bus auto-suspend
[   16.805068] usb usb7: suspend_rh
[   16.805082] hub 6-0:1.0: hub_suspend
[   16.805084] usb usb6: bus auto-suspend
[   16.805085] usb usb6: suspend_rh
[   16.805099] hub 4-0:1.0: hub_suspend
[   16.805101] usb usb4: bus auto-suspend
[   16.805102] usb usb4: suspend_rh
[   16.805117] hub 3-0:1.0: hub_suspend
[   16.805119] usb usb3: bus auto-suspend
[   16.805120] usb usb3: suspend_rh
[   17.355706] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[   18.145925] set status page addr 0x01fff000
[   18.145948] [drm:i915_set_status_page] *ERROR* can not ioremap virtual address for G33 hw status page
[   18.492672] e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
[   18.549165] e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
[   18.550031] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   21.837798] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   21.838030] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   32.797035] eth0: no IPv6 routers present

-andy
