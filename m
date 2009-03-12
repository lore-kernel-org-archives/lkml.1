Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbZCLEl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbZCLEl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 00:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZCLElQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 00:41:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51105 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbZCLElO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 00:41:14 -0400
Date: Thu, 12 Mar 2009 13:39:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/5] memcg softlimit (Another one) v4
Message-Id: <20090312133949.130b20ed.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090312034647.GA23583@balbir.in.ibm.com>
References: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090312034647.GA23583@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 09:16:47 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-12 09:52:47]:
> I've tested so far by
> 
> Creating two cgroups and then 
> 
> a. Assigning limits of 1G and 2G and run memory allocation and touch
> test
softlimit ?

> b. Same as (a) with 1G and 1G
> c. Same as (a) with 0 and 1G
> d. Same as (a) with 0 and 0
> 
> More comments in induvidual patches.
> 
Then,
  1. what's the number of active threads ?
  2. what's the number of cpus ?
  3. what's the numa configuration, if numa ?
  4. what's the zone configuration ?
  5. what's arch ?
  6. what's amount of total memory ?
  7. Do you find difference in behavior with and without softlimit ?
  8. Do you tested *this* version ?

Thanks,
-Kame


> -- 
> 	Balbir
> 

