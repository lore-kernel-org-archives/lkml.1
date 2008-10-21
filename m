Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbYJUKs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbYJUKs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 06:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYJUKsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 06:48:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49454 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbYJUKst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 06:48:49 -0400
Message-ID: <48FDB38C.4000203@cn.fujitsu.com>
Date: Tue, 21 Oct 2008 18:48:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Rik van Riel <riel@redhat.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, lee.schermerhorn@hp.com
Subject: Re: [crash, -git] NULL pointer dereference, IP: [<c0190884>] page_cgroup_zoneinfo+0xf/0x1b
References: <20081021100935.GA7100@elte.hu> <20081021192143.67361afc.kamezawa.hiroyu@jp.fujitsu.com> <20081021103843.GA18150@elte.hu> <48FDB23D.6080603@linux.vnet.ibm.com>
In-Reply-To: <48FDB23D.6080603@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  nr of bisection commits: 14
>>  ----------------------------
>>  656eb2c: add CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
>>  6409324: coredump: format_corename: don't append .%pid if  multi-threaded
>>  b747c8c: make ptrace_untrace() static
>>  c459643: bitmask: remove bitmap_scnprintf_len()
>>  30e8e13: cpuset: use seq_*mask_* to print masks
>>  3eda201: seq_file: add seq_cpumask_list(), seq_nodemask_list()
>>  85dd030: seq_file: don't call bitmap_scnprintf_len()
>>  40b6a76: cpuset.c: remove extra variable
>>  52d4b9a: memcg: allocate all page_cgroup at boot

The bug should be introduced by this patch.

>>  c05555b: memcg: atomic ops for page_cgroup->flags
>>  addb9ef: memcg: optimize per-cpu statistics
>>  5b4e655: memcg: avoid accounting special pages
>>  b7abea9: memcg: make page->mapping NULL before uncharge
>>  073e587: memcg: move charge swapin under lock
>>
>> i'll poke in the middle - maybe i'm lucky and can find a 
>> working/crashing tree to nudge the bisection back into life.
> 
> Hi, Ingo,
> 
> Li Zefan has reported this problem and Kamezawa is looking into it.

Yes, but seems a bit tough...

> I am unwell,
> I hope to look into the problem when I feel better or at-least in the intervals
> of time that I feel better.
> 
