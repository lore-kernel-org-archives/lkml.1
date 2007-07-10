Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbXGJPZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbXGJPZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 11:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbXGJPZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 11:25:25 -0400
Received: from xenotime.net ([66.160.160.81]:45756 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754245AbXGJPZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 11:25:24 -0400
Date: Tue, 10 Jul 2007 08:29:04 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: balbir@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Menage <menage@google.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [patch -rss] Make RSS accounting display more user friendly
Message-Id: <20070710082904.b0faaddd.rdunlap@xenotime.net>
In-Reply-To: <46930EAF.6030104@linux.vnet.ibm.com>
References: <20070620154655.13844.42876.sendpatchset@balbir-laptop>
	<6599ad830706211217l65d76d4ehb42f9165bcf45dd@mail.gmail.com>
	<467B2F4F.2030101@openvz.org>
	<6599ad830706220839h2a556c76he11b78c2c4cdb86e@mail.gmail.com>
	<661de9470706222048g638a06dboc0b2e85975a9ba70@mail.gmail.com>
	<6599ad830706250019h117ff575h156cf112f5778e43@mail.gmail.com>
	<6D63B142.2080404@linux.vnet.ibm.com>
	<1183981098.1913.22.camel@twins>
	<46930EAF.6030104@linux.vnet.ibm.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jul 2007 21:44:31 -0700 Balbir Singh wrote:

> Peter Zijlstra wrote:
> > On Sun, 2028-02-27 at 02:39 -0500, Balbir Singh wrote:
> > 
> >> I am not a CLUI expert, but rounding off bytes will something that
> >> the administrators will probably complain about. Since we manage
> >> the controller memory in pages, it might be the easiest unit to use.
> >> The output is totally different matter.
> >>
> >> Having said that, I am not opposed to your suggestion, I'll see if
> >> I can find good CLUI guidelines.
> > 
> > Pages are generally considered a bad unit for user-space exposed
> > parameters because a page can have a wide spectrum of sizes on some
> > machines.
> > 
> 
> Exactly!
> 
> > The typical unit used in its stead is KiB. Although I could imagine MiB
> > being more useful in this case :-)
> > 
> 
> I think a routine that can handle either KiB or MiB would probably be the best
> 
> > Perhaps a new proc parser that takes postfix [KMG] units would be
> > handy..
> > 
> 
> Hmm.. yes.. a library routine would be nice!

you mean something like lib/cmdline.c::memparse() ?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
