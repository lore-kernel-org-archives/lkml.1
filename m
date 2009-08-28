Return-Path: <linux-kernel-owner+w=401wt.eu-S1751680AbZH1E3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbZH1E3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 00:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbZH1E3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 00:29:22 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:60143 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbZH1E3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 00:29:21 -0400
Date: Fri, 28 Aug 2009 09:58:36 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 0/5] memcg: reduce lock conetion
Message-ID: <20090828042836.GD4889@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-28 13:20:15]:

> Hi,
> 
> Recently, memcg's res_counter->lock contention on big server is reported and
> Balbir wrote a workaround for root memcg.
> It's good but we need some fix for children, too.
> 
> This set is for reducing lock conetion of memcg's children cgroup based on mmotm-Aug27.
> 
> I'm sorry I have only 8cpu machine and can't reproduce very troublesome lock conention.
> Here is lock_stat of make -j 12 on my 8cpu box, befre-after this patch series.
>

Kamezawa-San,

I've been unable to get mmotm to boot (24th August, I'll try the 27th
Aug and debug). Once that is done, I'll test on a large machine.
 
-- 
	Balbir
