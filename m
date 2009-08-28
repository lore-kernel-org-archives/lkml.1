Return-Path: <linux-kernel-owner+w=401wt.eu-S1751656AbZH1Eft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbZH1Eft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 00:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbZH1Efs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 00:35:48 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50902 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbZH1Efs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 00:35:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 Aug 2009 13:33:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 0/5] memcg: reduce lock conetion
Message-Id: <20090828133355.6b935757.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090828042836.GD4889@balbir.in.ibm.com>
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com>
	<20090828042836.GD4889@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009 09:58:36 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-28 13:20:15]:
> 
> > Hi,
> > 
> > Recently, memcg's res_counter->lock contention on big server is reported and
> > Balbir wrote a workaround for root memcg.
> > It's good but we need some fix for children, too.
> > 
> > This set is for reducing lock conetion of memcg's children cgroup based on mmotm-Aug27.
> > 
> > I'm sorry I have only 8cpu machine and can't reproduce very troublesome lock conention.
> > Here is lock_stat of make -j 12 on my 8cpu box, befre-after this patch series.
> >
> 
> Kamezawa-San,
> 
> I've been unable to get mmotm to boot (24th August, I'll try the 27th
> Aug and debug). Once that is done, I'll test on a large machine.
>  
yep, take it easy. I'm now very active in this weekend, anyway.

BTW, have you tried this ?

http://marc.info/?l=linux-kernel&m=125136796932491&w=2

Thanks,
-Kame

