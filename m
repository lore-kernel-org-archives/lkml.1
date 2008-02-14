Return-Path: <linux-kernel-owner+w=401wt.eu-S935320AbYBNAcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935320AbYBNAcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934729AbYBNA1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:27:35 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44990 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934600AbYBNA1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:27:31 -0500
Date: Thu, 14 Feb 2008 09:25:26 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 4/8][for -mm] mem_notify v6: memory_pressure_notify() caller
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, marcelo@kvack.org,
       daniel.spang@gmail.com, riel@redhat.com, alan@lxorguk.ukuu.org.uk,
       linux-fsdevel@vger.kernel.org, pavel@ucw.cz, a1426z@gawab.com,
       jonathan@jonmasters.org, zlynx@acm.org
In-Reply-To: <p73y79o290h.fsf@bingen.suse.de>
References: <20080213152204.D894.KOSAKI.MOTOHIRO@jp.fujitsu.com> <p73y79o290h.fsf@bingen.suse.de>
Message-Id: <20080214090740.C1B0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

> > to be honest, I don't think at mem-cgroup until now.
> 
> There is not only mem-cgroup BTW, but also NUMA node restrictons from
> NUMA memory policy. So this means a process might not be able to access
> all memory.

you are right.
good point out.

current implementation may cause wake up the no relate process of
memory shortage zone ;-)

but unfortunately, we can't know per zone rss.
(/proc/[pid]/numa_maps is very slow, we can't use it
 at memory shortage emergency)

I think we need develop per zone rss.
it become not only improve mem_notify, but also improve
oom killer of more intelligent process choice.

but it is a bit difficult. (at least for me ;-)
may be, I will implement it a bit later...


Thanks again!
your good opnion may improve my patch.


- kosaki


