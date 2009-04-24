Return-Path: <linux-kernel-owner+w=401wt.eu-S1758490AbZDXEey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbZDXEey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 00:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbZDXEel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 00:34:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37235 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbZDXEek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 00:34:40 -0400
Date: Fri, 24 Apr 2009 13:33:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh@veritas.com" <hugh@veritas.com>
Subject: Re: [RFC][PATCH] fix swap entries is not reclaimed in proper way
 for mem+swap controller
Message-Id: <20090424133306.0d9fb2ce.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090422143833.2e11e10b.nishimura@mxp.nes.nec.co.jp>
References: <20090421162121.1a1d15fe.kamezawa.hiroyu@jp.fujitsu.com>
	<20090422143833.2e11e10b.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009 14:38:33 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> >  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
> >  extern void mem_cgroup_uncharge_swap(swp_entry_t ent);
> > +extern void mem_cgroup_mark_swapcache_stale(struct page *page);
> > +extern void mem_cgroup_fixup_swapcache(struct page *page);
> >  #else
> >  static inline void mem_cgroup_uncharge_swap(swp_entry_t ent)
> >  {
> >  }
> > +static void mem_cgroup_check_mark_swapcache_stale(struct page *page)
> > +{
> > +}
> > +static void mem_cgroup_fixup_swapcache(struct page *page)
> > +{
> > +}
> >  #endif
> >  
> I think they should be defined in MEM_RES_CTLR case.
> Exhausting swap entries problem is not depend on MEM_RES_CTLR_SWAP.
> 
Could you explain this more ? I can't understand.


Thanks,
-Kame

