Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbZD1DwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbZD1DwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 23:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZD1DwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 23:52:14 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:34595 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbZD1DwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 23:52:14 -0400
Date: Tue, 28 Apr 2009 12:49:45 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       nishimura@mxp.nes.nec.co.jp
Subject: Re: [PATCH] fix leak of swap accounting as stale swap cache under
 memcg
Message-Id: <20090428124945.04a47539.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <isapiwc.d5d1bc3c.6e29.49f6574a.db2ee.65@mail.jp.nec.com>
References: <20090427181259.6efec90b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090427210856.d5f4109e.d-nishimura@mtf.biglobe.ne.jp>
	<20090428091902.fc44efbc.kamezawa.hiroyu@jp.fujitsu.com>
	<isapiwc.d5d1bc3c.6e29.49f6574a.db2ee.65@mail.jp.nec.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> And I don't think it's a good idea to add memcg_stale_swap_congestion() here.
> >> This means less possibility to reclaim pages.
> >> 
> > Hmm. maybe adding congestion_wait() ?
> > 
> I don't think no hook before add_to_swap() is needed.
> 
s/don't//

Sorry for my poor English.

Daisuke Nishimura.
