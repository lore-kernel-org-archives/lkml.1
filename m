Return-Path: <linux-kernel-owner+w=401wt.eu-S1762590AbZDHGRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762590AbZDHGRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759817AbZDHGRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:17:03 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60077 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758814AbZDHGRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:17:00 -0400
Date: Wed, 8 Apr 2009 15:15:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       Rik van Riel <riel@surriel.com>, Bharata B Rao <bharata.rao@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFI] Shared accounting for memory resource controller
Message-Id: <20090408151529.fd6626c2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090408052904.GY7082@balbir.in.ibm.com>
References: <20090407063722.GQ7082@balbir.in.ibm.com>
	<20090407160014.8c545c3c.kamezawa.hiroyu@jp.fujitsu.com>
	<20090407071825.GR7082@balbir.in.ibm.com>
	<20090407163331.8e577170.kamezawa.hiroyu@jp.fujitsu.com>
	<20090407080355.GS7082@balbir.in.ibm.com>
	<20090407172419.a5f318b9.kamezawa.hiroyu@jp.fujitsu.com>
	<20090408052904.GY7082@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009 10:59:04 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:


> > no serious intention.
> > Just because you wrote "expect the user to account all cached pages as shared" ;)
> >
> 
> OK, I noticed another thing, our RSS accounting is not RSS per-se, it
> includes only anon RSS, file backed pages are accounted as cached.
> I'll send out a patch to see if we can include anon RSS as well.
>  

I think we can't do it in memcg layer without new-hook because file caches
are added to radix-tree before mapped.

mm struct has anon_rss and file_rss coutners. Then, you can show
sum of total maps of file pages. maybe.

Thanks,
-Kame

