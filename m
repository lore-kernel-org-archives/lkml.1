Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbZC3X5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbZC3X5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 19:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbZC3X5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 19:57:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60754 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbZC3X5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 19:57:10 -0400
Date: Tue, 31 Mar 2009 08:55:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH] memcg soft limit (yet another new design) v1
Message-Id: <20090331085538.2aaa5e2b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090328182747.GA8339@balbir.in.ibm.com>
References: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com>
	<20090328181100.GB26686@balbir.in.ibm.com>
	<20090328182747.GA8339@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Mar 2009 23:57:47 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Balbir Singh <balbir@linux.vnet.ibm.com> [2009-03-28 23:41:00]:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-27 13:59:33]:
> > 
> > > ==brief test result==
> > > On 2CPU/1.6GB bytes machine. create group A and B
> > >   A.  soft limit=300M
> > >   B.  no soft limit
> > > 
> > >   Run a malloc() program on B and allcoate 1G of memory. The program just
> > >   sleeps after allocating memory and no memory refernce after it.
> > >   Run make -j 6 and compile the kernel.
> > > 
> > >   When vm.swappiness = 60  => 60MB of memory are swapped out from B.
> > >   When vm.swappiness = 10  => 1MB of memory are swapped out from B    
> > > 
> > >   If no soft limit, 350MB of swap out will happen from B.(swapiness=60)
> > >
> > 
> > I ran the same tests, booted the machine with mem=1700M and maxcpus=2
> > 
> > Here is what I see with
> 
> I meant to say, Here is what I see with my patches (v7)
> 
Hmm, I saw 250MB of swap out ;) As I reported before.

-Kame


