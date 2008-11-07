Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbYKGBV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbYKGBV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 20:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYKGBVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 20:21:17 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:40670 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbYKGBVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 20:21:16 -0500
Date: Fri, 7 Nov 2008 10:19:05 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "menage@google.com" <menage@google.com>, nishimura@mxp.nes.nec.co.jp
Subject: Re: [RFC][PATCH 4/6] memcg : swap cgroup
Message-Id: <20081107101905.268533fb.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <29542.10.75.179.61.1225975461.squirrel@webmail-b.css.fujitsu.com>
References: <20081105171637.1b393333.kamezawa.hiroyu@jp.fujitsu.com>
	<20081105172141.1a12dc23.kamezawa.hiroyu@jp.fujitsu.com>
	<20081106202534.80e5cf0a.nishimura@mxp.nes.nec.co.jp>
	<29542.10.75.179.61.1225975461.squirrel@webmail-b.css.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008 21:44:21 +0900 (JST), "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Daisuke Nishimura said:
> > On Wed, 5 Nov 2008 17:21:41 +0900, KAMEZAWA Hiroyuki
> > <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >> Note1: In this, we use pointer to record information and this means
> >>       8bytes per swap entry. I think we can reduce this when we
> >>       create "id of cgroup" in the range of 0-65535 or 0-255.
> >>
> >> Note2: array of swap_cgroup is allocated from HIGHMEM. maybe good for
> >> x86-32.
> >>
> >> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >>
> >>  include/linux/page_cgroup.h |   35 +++++++
> >>  mm/page_cgroup.c            |  201
> >> ++++++++++++++++++++++++++++++++++++++++++++
> >>  mm/swapfile.c               |    8 +
> >>  3 files changed, 244 insertions(+)
> >>
> > Is there any reason why they are defined not in memcontrol.[ch]
> > but in page_cgroup.[ch]?
> >
> no strong reason. just because this is not core logic for acccounting.
> do you want to see this in memcontrol.c ?
> 
I just felt strange just because they are not "page_cgroup".
I don't have any strong request to move them to memcontrol.c.


Thanks,
Daisuke Nishimura.
