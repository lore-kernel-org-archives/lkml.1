Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbZAIGB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbZAIGB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 01:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbZAIGBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 01:01:12 -0500
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:52844 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbZAIGBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 01:01:10 -0500
Date: Fri, 9 Jan 2009 11:31:09 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com
Subject: Re: [RFC][PATCH 2/4] memcg: fix error path of
	mem_cgroup_move_parent
Message-ID: <20090109060109.GG9737@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp> <20090108191445.cd860c37.nishimura@mxp.nes.nec.co.jp> <20090109051522.GC9737@balbir.in.ibm.com> <20090109143346.5ad2b971.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090109143346.5ad2b971.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> [2009-01-09 14:33:46]:

> > Looks good to me, just out of curiousity how did you catch this error?
> > Through review or testing? 
> > 
> Through testing.
> 
> I got "an unremovable directory" sometimes, which had res.usage remained
> even after all lru lists had become empty, or which had ref counts remained
> even after res.usage had become 0.
> And tracked down the cause of this problem .
>

Thanks,

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com> 

-- 
	Balbir
