Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbYLCFVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbYLCFVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 00:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbYLCFVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 00:21:32 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60673 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYLCFVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 00:21:31 -0500
Date: Wed, 3 Dec 2008 14:20:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH  0/21] memcg updates 2008/12/03
Message-Id: <20081203142040.065c184d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081203134718.6b60986f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081203134718.6b60986f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008 13:47:18 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> This is memcg update series onto
> "The mm-of-the-moment snapshot 2008-12-02-17-08"
> 
> including following patches. 18-21 are highly experimenal
> (so, drop CC: to Andrew)
> 
> Bug fixes.
> 1. memcg-revert-gfp-mask-fix.patch 
> 2. memcg-check-group-leader-fix.patch
> 3. memsw_limit_check.patch
> 4. memcg-swapout-refcnt-fix.patch
> 5. avoid-unnecessary-reclaim.patch
> 
> Kosaki's LRU works. (thanks!)
> 6.  inactive_anon_is_low-move-to-vmscan.patch
> 7.  introduce-zone_reclaim-struct.patch
> 8.  make-zone-nr_pages-helper-function.patch
> 9.  make-get_scan_ratio-to-memcg-safe.patch
> 10. memcg-add-null-check-to-page_cgroup_zoneinfo.patch
> 11. memcg-make-inactive_anon_is_low.patch
> 12. memcg-make-mem_cgroup_zone_nr_pages.patch
> 13. memcg-make-zone_reclaim_stat.patch
> 14. memcg-remove-mem_cgroup_cal_reclaim.patch
> 15. memcg-show-reclaim-stat.patch
> Cleanup
> 16. memcg-rename-scan-glonal-lru.patch
> Bug fix 
> 16. memcg_prev_priority_protect.patch
double counts here ..sigh...

If mmotm eats too patches to apply this, I'll post again in Friday.

BTW, Balbir, "21" (really 22/21) meets your request ?

Thanks,
-Kame

