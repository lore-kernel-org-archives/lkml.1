Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbZF2ENs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbZF2ENs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 00:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbZF2ENk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 00:13:40 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:47079 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZF2ENk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 00:13:40 -0400
Date: Mon, 29 Jun 2009 13:10:37 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memcg: cgroup fix rmdir hang
Message-Id: <20090629131037.bdd56fb0.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090626150052.362e1819.nishimura@mxp.nes.nec.co.jp>
References: <20090623160720.36230fa2.kamezawa.hiroyu@jp.fujitsu.com>
	<20090626141020.849a081e.kamezawa.hiroyu@jp.fujitsu.com>
	<20090626150052.362e1819.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009 15:00:52 +0900, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> On Fri, 26 Jun 2009 14:10:20 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > I hope this will be a final bullet..
> > I myself think this one is enough simple and good.
> I think so too :)
> Using test_and_clear_bit() and checking CGRP_WAIT_ON_RMDIR before sleeping
> would be a good idea to make the patch simple.
> 
> > I'm sorry that we need test again.
> No problem.
> I'll test this one this weekend.
> 
It has survived my test(rmdir under memory pressure) this weekend.
Please feel free to add my Tested-by.

	Tested-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Thanks,
Daisuke Nishimura.
