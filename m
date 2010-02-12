Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab0BLCpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 21:45:06 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39945 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757817Ab0BLCpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 21:45:04 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 12 Feb 2010 11:41:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, stable@kernel.org,
       rientjes@google.com,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [BUGFIX][PATCH] memcg: fix oom killing a child process in an 
 other cgroup
Message-Id: <20100212114133.57bb1141.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28c262361002111839t291b8ac2xdb9b89b354a115e0@mail.gmail.com>
References: <20100212105318.caf37133.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262361002111839t291b8ac2xdb9b89b354a115e0@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 11:39:35 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Fri, Feb 12, 2010 at 10:53 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > This patch itself is againt mmotm-Feb10 but can be applied to 2.6.32.8
> > without problem.
> >
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> > Now, oom-killer is memcg aware and it finds the worst process from
> > processes under memcg(s) in oom. Then, it kills victim's child at first.
> > It may kill a child in other cgroup and may not be any help for recovery.
> > And it will break the assumption users have...
> >
> > This patch fixes it.
> >
> > CC: stable@kernel.org
> > CC: Minchan Kim <minchan.kim@gmail.com>
> > CC: Balbir Singh <balbir@linux.vnet.ibm.com>
> > CC: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> > Acked-by: David Rientjes <rientjes@google.com>
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> 
> Sorry for noise, Kame.
> 
No problem. You give me a chance to consider other problems/dirtiness of codes.
I continue review to make memcg cleaer.

Thanks,
-Kame

