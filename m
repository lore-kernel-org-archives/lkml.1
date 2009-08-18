Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbZHRMnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbZHRMnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 08:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZHRMnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 08:43:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:50816 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbZHRMnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 08:43:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,402,1246863600"; 
   d="scan'208";a="177037894"
Date: Tue, 18 Aug 2009 20:00:32 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Thomas Gleixner <tglx@linutronix.de>, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [Patch] proc: drop write permission on 'timer_list' and
	'slabinfo'
Message-ID: <20090818120032.GA22152@localhost>
References: <20090817094525.6355.88682.sendpatchset@localhost.localdomain> <20090817094822.GA17838@elte.hu> <1250502847.5038.16.camel@penberg-laptop> <alpine.DEB.1.10.0908171228300.16267@gentwo.org> <4A8986BB.80409@cs.helsinki.fi> <alpine.DEB.1.10.0908171240370.16267@gentwo.org> <4A8A0B0D.6080400@redhat.com> <4A8A0B14.8040700@cn.fujitsu.com> <4A8A1B2E.20505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8A1B2E.20505@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 11:08:30AM +0800, Amerigo Wang wrote:

> -	proc_create("slabinfo",S_IWUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
> +	proc_create("slabinfo",S_IRUGO,NULL,&proc_slabinfo_operations);

Style nitpick. The spaces were packed to fit into 80-col I guess.


ERROR: space required after that ',' (ctx:VxV)
#10: FILE: mm/slub.c:4729:
+       proc_create("slabinfo",S_IRUGO,NULL,&proc_slabinfo_operations);
                              ^

ERROR: space required after that ',' (ctx:VxV)
#10: FILE: mm/slub.c:4729:
+       proc_create("slabinfo",S_IRUGO,NULL,&proc_slabinfo_operations);
                                      ^

ERROR: space required after that ',' (ctx:VxO)
#10: FILE: mm/slub.c:4729:
+       proc_create("slabinfo",S_IRUGO,NULL,&proc_slabinfo_operations);
                                           ^

ERROR: space required before that '&' (ctx:OxV)
#10: FILE: mm/slub.c:4729:
+       proc_create("slabinfo",S_IRUGO,NULL,&proc_slabinfo_operations);
                                            ^

Thanks,
Fengguang
