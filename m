Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532Ab0AGMit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab0AGMit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 07:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404Ab0AGMis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 07:38:48 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:49866 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab0AGMis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 07:38:48 -0500
Date: Thu, 7 Jan 2010 18:08:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: nishimura@mxp.nes.nec.co.jp
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: How should we handle CONFIG_CGROUP_MEM_RES_CTRL_SWAP (Re: [PATCH
 -mmotm] build fix for memcg-move-charges-of-anonymous-swap.patch)
Message-ID: <20100107123841.GX3059@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100106171058.f1d6f393.randy.dunlap@oracle.com>
 <20100107111319.7d95fe86.nishimura@mxp.nes.nec.co.jp>
 <20100107112150.2e585f1c.kamezawa.hiroyu@jp.fujitsu.com>
 <20100107115901.594330d0.nishimura@mxp.nes.nec.co.jp>
 <20100107120233.f244d4b7.kamezawa.hiroyu@jp.fujitsu.com>
 <20100107130609.31fe83dc.nishimura@mxp.nes.nec.co.jp>
 <20100107133026.6350bd9d.kamezawa.hiroyu@jp.fujitsu.com>
 <20100107141401.6a182085.nishimura@mxp.nes.nec.co.jp>
 <20100107145223.a73e2be9.kamezawa.hiroyu@jp.fujitsu.com>
 <20100107202335.c18b728b.d-nishimura@mtf.biglobe.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100107202335.c18b728b.d-nishimura@mtf.biglobe.ne.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp> [2010-01-07 20:23:35]:

> (Changed the subject and Cc list)
> 
> On Thu, 7 Jan 2010 14:52:23 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > BTW, maybe it's time to
> >   - remove EXPERIMENTAL from CONFIG_CGROUP_MEM_RES_CTRL_SWAP
> > and more,
> >   - remove CONFIG_CGROUP_MEM_RES_CTRL_SWAP
> >     (to reduce complicated #ifdefs and replace them with CONFIG_SWAP.)
> > 
> > It's very stable as far as I test.
> > 
> I agree on both.
> 
> Balbir-san, What do you think ?
>

I agree, the experimental marking can go and CONFIG_SWAP can replace
the current config option. 

-- 
	Balbir
