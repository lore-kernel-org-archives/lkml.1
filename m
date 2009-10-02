Return-Path: <linux-kernel-owner+w=401wt.eu-S1757166AbZJBHGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166AbZJBHGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 03:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbZJBHGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 03:06:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57407 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251AbZJBHGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 03:06:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 2 Oct 2009 16:04:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nis@tyo205.gate.nec.co.jp>
Subject: Re: [PATCH 1/2] memcg: coalescing uncharge at unmap and truncation
Message-Id: <20091002160437.4871306f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4AC5A35F.3040308@ct.jp.nec.com>
References: <20091002135531.3b5abf5c.kamezawa.hiroyu@jp.fujitsu.com>
	<20091002140126.61d15e5e.kamezawa.hiroyu@jp.fujitsu.com>
	<4AC5A1FA.1080208@ct.jp.nec.com>
	<4AC5A35F.3040308@ct.jp.nec.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Oct 2009 15:53:19 +0900
Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> Hiroshi Shimamoto wrote:
> > KAMEZAWA Hiroyuki wrote:

> >> +static inline void mem_cgroup_uncharge_batch_start(void)
> >> +{
> >> +}
> >> +
> >> +static inline void mem_cgroup_uncharge_batch_start(void)
> > 
> > mem_cgroup_uncharge_batch_end?
> 
> s/_batch// too?
> 
thank you. fixed.

-Kame

