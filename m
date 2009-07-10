Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbZGJNKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbZGJNKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 09:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbZGJNK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 09:10:26 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:63372 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZGJNKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 09:10:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19031.15772.404288.544946@stoffel.org>
Date: Fri, 10 Jul 2009 09:09:48 -0400
From: "John Stoffel" <john@stoffel.org>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: "John Stoffel" <john@stoffel.org>, Wu Fengguang <fengguang.wu@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Minchan Kim <minchan.kim@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: OOM killer in 2.6.31-rc2
In-Reply-To: <200907091703.06691.gene.heskett@verizon.net>
References: <200907061056.00229.gene.heskett@verizon.net>
	<200907091042.38022.gene.heskett@verizon.net>
	<19030.22024.132029.196682@stoffel.org>
	<200907091703.06691.gene.heskett@verizon.net>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Gene" == Gene Heskett <gene.heskett@verizon.net> writes:

Gene> On Thursday 09 July 2009, John Stoffel wrote:
>>>>>>> "Gene" == Gene Heskett <gene.heskett@verizon.net> writes:
>> 
Gene> On Wednesday 08 July 2009, Wu Fengguang wrote:
>>>> On Wed, Jul 08, 2009 at 01:15:15PM +0800, Wu Fengguang wrote:
>>>>> On Tue, Jul 07, 2009 at 11:42:07PM -0400, Gene Heskett wrote:
>> 
Gene> [...]
>> 
>>>>> I guess your near 800MB slab cache is somehow under scanned.
>>>> 
>>>> Gene, can you run .31 with this patch? When OOM happens, it will tell
>>>> us whether the majority slab pages are reclaimable. Another way to
>>>> find things out is to run `slabtop` when your system is moderately
>>>> loaded.
>> 
Gene> Its been running continuously, and after 24 hours is now showing:
>> 
>> Just wondering, is this your M2N-SLI Deluxe board?
Gene> Yes.
>> I've got the same
>> board, with 4Gb of RAM and I haven't noticed any loss of RAM from my
>> looking (quickly) at top output.

Gene> I am short approximately 500 megs according to top:
Gene> Mem:   3634228k total,  3522984k used,   111244k free,   308096k buffers
Gene> Swap:  8385912k total,      568k used,  8385344k free,  2544716k cached

Gene> From dmesg:
Gene> [    0.000000] TOM2: 0000000120000000 aka 4608M  <what is this?
Gene> [...]
Gene> [    0.000000] 2694MB HIGHMEM available.
Gene> [    0.000000] 887MB LOWMEM available.

Gene> The bios signon does say 4092M IIRC.

>> But I also haven't bothered to upgrade the BIOS on this board at all
>> since I got it back in March of 2008.  No need in my book so far.

Gene> I had been running the original bios, #1502, because 1604 and
Gene> 1701 had very poor uptimes.  1502 caused an oops about 15 lines
Gene> into the boot but that triggered a remap and it was bulletproof
Gene> after that running a 32 bit 64G+PAE kernel.  (I haven't quite
Gene> made the jump to a 64 bit install, yet...)

Why haven't you made the laep to 64bit yet?  To me, that seems to be
the real solution here, not hacks like the HIGHMEM4G and HIGHMEM64G,
esp when your hardware is 64Bit by default.  

I've made the leap and I've never looked back.  Haven't missed any
32bit only apps, and if I really needed them, I'd just load the 32bit
libraries if need be.

John
