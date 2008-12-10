Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbYLJDEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbYLJDEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 22:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbYLJDEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 22:04:14 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50149 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbYLJDEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 22:04:13 -0500
Date: Wed, 10 Dec 2008 12:03:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 4/6] Flat hierarchical reclaim by ID
Message-Id: <20081210120317.5dce40fa.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081210024929.GG7593@balbir.in.ibm.com>
References: <20081209200213.0e2128c1.kamezawa.hiroyu@jp.fujitsu.com>
	<20081209200915.41917722.kamezawa.hiroyu@jp.fujitsu.com>
	<20081209122731.GB4174@balbir.in.ibm.com>
	<3526.10.75.179.61.1228832912.squirrel@webmail-b.css.fujitsu.com>
	<20081209154612.GB7694@balbir.in.ibm.com>
	<36125.10.75.179.61.1228840454.squirrel@webmail-b.css.fujitsu.com>
	<20081210024929.GG7593@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 08:19:29 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > >> >From implementation, hierarchy code management at el. should go into
> > >> cgroup.c and it gives us clear view rather than implemented under memcg.
> > >>
> > >
> > > cgroup has hierarchy management already, in the form of children and
> > > sibling. Walking those structures is up to us, that is all we do
> > > currently :)
> > >
> > yes, but need cgroup_lock(). and you have to keep refcnt to pointer
> > just for rememebring it.
> > 
> > This patch doesn't change anything other than removing cgroup_lock() and
> > removing refcnt to remember start point.
> >
> 
> OK, I'll play with it 
> 
I hear Kosaki has another idea to 5/6. So please ignore 5/6 for a while.
It's complicated. I'll post updated ones.

-Kame

