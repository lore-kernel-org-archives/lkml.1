Return-Path: <linux-kernel-owner+w=401wt.eu-S1751851AbZGXIKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbZGXIKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 04:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZGXIKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 04:10:20 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48782 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbZGXIKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 04:10:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 24 Jul 2009 17:08:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: xiyou.wangcong@gmail.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       ralf@linux-mips.org, benh@kernel.crashing.org, lethal@linux-sh.org
Subject: [RFC][PATCH 0/6] kcore clean up and enhance. v3
Message-Id: <20090724170819.2625ba07.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, back to RFC again. 2 patches are added.

Now, /proc/kcore is not aware of physical memory layout and has no hooks for
memory hotplug. I'm trying to fix it. But at doing so, I've wrote several
clean-up patches unexpectedly ;)

Now, /proc/kcore has per-arch hooks to x86-32/64, sh, mips, ia64,
powerpc-32/64. I think I know x86-32/64's and ia64 memory layout well,
but not sure about others. Then, I CCed to maintainers. please notify me
if any concerns.
After this, most of arch-specific codes can be removed.
(x86-64 and mips-64bit seems to have something special.)

Patches
[1/6] kcore clean up/ use usual list ops 
[2/6] kcore clean up/ add kclist type.
[3/6] kcore clean up/ unifiy per-arch vmalloc kclist_add()
[4/6] kcore clean up/ unifiy per-arch text range kclist_add()
[5/6] kcore enhance / use precise physical memory check and support hotplug.
[6/6] generic: rewrite walk_memory_resource as to be  walk_system_ram_range().

Any comments are welcome.
I'm sorry that I may not be able to make a quick reply.

Thanks,
-Kame

