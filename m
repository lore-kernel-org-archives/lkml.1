Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbXGaFBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbXGaFBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 01:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967447AbXGaFAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 01:00:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35038 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965764AbXGaFAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 01:00:50 -0400
Date: Tue, 31 Jul 2007 14:02:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "David Mosberger-Tang" <dmosberger@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       "Zoltan.Menyhart@bull.net" <Zoltan.Menyhart@bull.net>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH] flush icache before set_pte take6. [4/4] optimization
 for cpus other than montecito
Message-Id: <20070731140213.5469a775.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070731132932.8e21d48c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070731113543.93ffd964.kamezawa.hiroyu@jp.fujitsu.com>
	<20070731114155.5785123c.kamezawa.hiroyu@jp.fujitsu.com>
	<ed5aea430707302115h484620f1le51fc054436b273a@mail.gmail.com>
	<20070731132932.8e21d48c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 13:29:32 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Mon, 30 Jul 2007 22:15:50 -0600
> "David Mosberger-Tang" <dmosberger@gmail.com> wrote:
> 
> > This seems crazy to me.  Flushing should occur according to the
> > *architecture*, not model-by-model.  Even if we happen to get "lucky"
> > on pre-Montecito CPUs, that doesn't justify such ugly hacks.  
> 

BTW, how about the quality of patch[2/4] ?

If it is enough well, I want it to be merged....

please..
-Kame

