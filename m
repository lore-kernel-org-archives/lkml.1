Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbYCRAr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbYCRAr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 20:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYCRArT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 20:47:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49242 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbYCRArS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 20:47:18 -0400
Date: Tue, 18 Mar 2008 09:47:04 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish >12 hour
Cc: kosaki.motohiro@jp.fujitsu.com, "Luck, Tony" <tony.luck@intel.com>,
       "LKML" <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <DDF46CB71CB9D647A983FECACF09A886A33019@orsmsx424.amr.corp.intel.com>
References: <20080318084314.FF0F.KOSAKI.MOTOHIRO@jp.fujitsu.com> <DDF46CB71CB9D647A983FECACF09A886A33019@orsmsx424.amr.corp.intel.com>
Message-Id: <20080318094527.FF12.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yu-san,

> > > % ./hackbench 130 process 500
> > > 2.6.25-rc5:     works well
> > > 2.6.25-rc5-mm1: doesn't finish >12 hour
> >cpu: Itanium2 x8
> >mem: 8GB(4GB x2 node)
> 
> On Itanium2x8 w/ 8GB on 1 node, All of 2.6.24, 2.6.25-rc5 and
> 2.6.25-rc5-mm1 shows same "out of memory" within one minute. I haven't
> seen spinlock lockup issue yet.

this paramter mean use all physical memory and about 1GB swap space.
Could you expand swap space?


- kosaki


