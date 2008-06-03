Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbYFCEfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbYFCEfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 00:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYFCEfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 00:35:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:32794 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYFCEfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 00:35:42 -0400
Date: Tue, 03 Jun 2008 13:35:13 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] vmallocinfo: Add NUMA informations
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4844BC75.8040705@cosmosbay.com>
References: <20080602160548.B6D4.KOSAKI.MOTOHIRO@jp.fujitsu.com> <4844BC75.8040705@cosmosbay.com>
Message-Id: <20080603133247.B6E0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +		for (nr = 0; nr < MAX_NUMNODES; nr++)
> >> +			if (counters[nr])
> >> +				seq_printf(m, " N%u=%u", nr, counters[nr]);
> >
> > for_each_node_state(n, N_HIGH_MEMORY) is better?
> > because MAX_NUMNODES has offten very large value.
> >   
> Yes, good idea, thank you.
> 
> I also used nr_node_ids instead of MAX_NUMNODES in this second version :

Thank you! looks goot to me.
and, my test fouund no bug.

	Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


Cristoph, What do you think?



