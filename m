Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbZA3Uzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbZA3Uzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 15:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbZA3Uzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 15:55:32 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:39430 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbZA3Uzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 15:55:31 -0500
Message-ID: <498368D2.6090307@oracle.com>
Date: Fri, 30 Jan 2009 12:53:38 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent	VM_LOCKED
 file segments
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>	 <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>	 <1233259410.2315.75.camel@lts-notebook>	 <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>	 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>	 <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com>	 <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain>	 <20090130055639.GA30950@suse.de>	 <alpine.LFD.2.00.0901300811260.3150@localhost.localdomain>	 <Pine.LNX.4.64.0901301724010.1563@blonde.anvils>	 <alpine.LFD.2.00.0901300946360.3150@localhost.localdomain> <1233345190.908.36.camel@lts-notebook>
In-Reply-To: <1233345190.908.36.camel@lts-notebook>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.498368D6.02D8:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Schermerhorn wrote:

> I tried this patch atop 29-rc3 + your patch from yesterday with my
> simple test program at http://free.linux/hp.com/~lts/Tests/mmap_lock.c. 

Is that URL correct?  I can't find/access it.

> The test program shows the /proc/<pid>/maps before and after the mmap
> and attempted merge.  It's not merging:

Thanks,
-- 
~Randy
