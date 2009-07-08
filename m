Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbZGHEfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbZGHEfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZGHEez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:34:55 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:45020 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZGHEey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:34:54 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: linux-kernel@vger.kernel.org
Subject: Odd git related msg in bootup of 2.6.30.1 w/o high_mem64G
Date: Wed, 08 Jul 2009 00:34:37 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.30.1; KDE/4.2.4; i686; ; )
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200907080034.37122.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

I just caught this in my log after rebooting to 2.6.30.1 built w/o the
HIGHMEM64G setting, which appears to cost me about 500 megs of the 4G that is 
in it.
===============================
Jul  8 00:18:58 coyote kernel: [  123.559920] nepomukservices[3680]: segfault at 4 ip 4d656eb2 sp bf980fa0 error 4 in 
libQtCore.so.4.5.1[4d60d000+232000]
Jul  8 00:19:01 coyote kernel: [  127.235168] BUG: Bad page state in process git  pfn:c7e13
Jul  8 00:19:01 coyote kernel: [  127.235173] page:c28fc260 flags:80004000 count:0 mapcount:0 mapping:(null) index:0
Jul  8 00:19:01 coyote kernel: [  127.235177] Pid: 3791, comm: git Not tainted 2.6.30.1 #4
Jul  8 00:19:01 coyote kernel: [  127.235179] Call Trace:
Jul  8 00:19:01 coyote kernel: [  127.235186]  [<c06f18b3>] ? printk+0x23/0x40
Jul  8 00:19:01 coyote kernel: [  127.235190]  [<c047916f>] bad_page+0xcf/0x150
Jul  8 00:19:01 coyote kernel: [  127.235194]  [<c047a66f>] get_page_from_freelist+0x3cf/0x4f0
Jul  8 00:19:01 coyote kernel: [  127.235198]  [<c0474007>] ? find_lock_page+0x27/0x80
Jul  8 00:19:01 coyote kernel: [  127.235202]  [<c047a963>] __alloc_pages_internal+0xc3/0x460
Jul  8 00:19:01 coyote kernel: [  127.235206]  [<c048ba84>] handle_mm_fault+0x3a4/0x660
Jul  8 00:19:01 coyote kernel: [  127.235211]  [<c041de09>] do_page_fault+0x139/0x280
Jul  8 00:19:01 coyote kernel: [  127.235214]  [<c041dcd0>] ? do_page_fault+0x0/0x280
Jul  8 00:19:01 coyote kernel: [  127.235217]  [<c06f5322>] error_code+0x7a/0x80
Jul  8 00:19:01 coyote kernel: [  127.235219] Disabling lock debugging due to kernel taint
==========================
This is also with the newest #1701 ASUS bios installed, which does not give me the
initial oopsen from a bad bios memory map that I get with #1502.  You have seen
that Oops in another post within the last 2 days.

Comments anybody?

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

God save us from a bad neighbor and a beginner on the fiddle.

