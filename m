Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329Ab0ALAxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab0ALAxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277Ab0ALAxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:53:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355Ab0ALAxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:53:12 -0500
Date: Mon, 11 Jan 2010 16:50:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Revert 2fbd07a5f so machines with BSPs phsyical apic id
 != 0 can boot
In-Reply-To: <alpine.LFD.2.00.1001111641180.17145@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001111648110.17145@localhost.localdomain>
References: <20100109101038.GA17555@in.ibm.com>  <86802c441001091313y1f64f011t616f08cd282a7123@mail.gmail.com>  <20100110023015.GA2253@in.ibm.com>  <86802c441001092235j79092e6fse18b61e3d7b0ac6@mail.gmail.com>  <20100110102638.GA7838@elte.hu> 
 <20100111045326.GA11725@in.ibm.com>  <1263245985.2859.497.camel@sbs-t61.sc.intel.com>  <alpine.LFD.2.00.1001111454060.17145@localhost.localdomain> <1263253513.2859.833.camel@sbs-t61.sc.intel.com> <alpine.LFD.2.00.1001111641180.17145@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 Jan 2010, Linus Torvalds wrote:
> 
> So no. I'm not going to take a resubmission. 

Just to clarify: it will not just need to resolve the issue that Anath saw 
(and NO BLACKLISTS - If you can't make the _same_ code work on all 
machines, don't even bother!), it needs to be less ugly and better 
documented too.

That whole intel-vs-amd test was just black magic, and apparently simply 
not even true. Let's not ever introduce that kind of voodoo programming 
again, ok?

			Linus
