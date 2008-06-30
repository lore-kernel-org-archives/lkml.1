Return-Path: <linux-kernel-owner+w=401wt.eu-S1757814AbYF3G33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbYF3G33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 02:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYF3G3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 02:29:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54344 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbYF3G3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 02:29:16 -0400
Message-ID: <4868779E.9050309@cn.fujitsu.com>
Date: Mon, 30 Jun 2008 14:05:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: further checking of disabled flag
References: <Pine.LNX.4.64.0806290108110.20280@blonde.site> <Pine.LNX.4.64.0806290115440.20280@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0806290115440.20280@blonde.site>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Further adjustments to the mem_cgroup_subsys.disabled tests: add one to
> mem_cgroup_shrink_usage; move mem_cgroup_charge_common's into its callers,
> before they've done any work; and add one to mem_cgroup_move_lists, to
> avoid the overhead of its bit spin locking and unlocking.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

> ---
> Should follow mmotm's memcg-clean-up-checking-of-the-disabled-flag.patch
> 

But this needn't follow memcg-clean-up-checking-of-the-disabled-flag.patch,
because this patch is not a fix to it. :)
