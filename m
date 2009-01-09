Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbZAIQrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbZAIQrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbZAIQq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:46:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbZAIQq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:46:56 -0500
Date: Fri, 9 Jan 2009 08:46:20 -0800
From: Dirk Hohndel <hohndel@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, jim owens <jowens@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
Message-ID: <20090109084620.3c711aad@infradead.org>
In-Reply-To: <49677CB1.3030701@zytor.com>
References: <20090108141808.GC11629@elte.hu>
	<1231426014.11687.456.camel@twins>
	<alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
	<1231434515.14304.27.camel@think.oraclecorp.com>
	<alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
	<20090108183306.GA22916@elte.hu>
	<496648C7.5050700@zytor.com>
	<alpine.LFD.2.00.0901081943150.6528@localhost.localdomain>
	<20090109130057.GA31845@elte.hu>
	<49675920.4050205@hp.com>
	<20090109153508.GA4671@elte.hu>
	<49677CB1.3030701@zytor.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hohndel@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jan 2009 08:34:57 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> As far as naming is concerned, gcc effectively supports four levels,
> which *currently* map onto macros as follows:
> 
> __always_inline		Inline unconditionally
> inline			Inlining hint
> <nothing>		Standard heuristics
> noinline		Uninline unconditionally
> 
> A lot of noise is being made about the naming of the levels (and I
> personally believe we should have a different annotation for "inline
> unconditionally for correctness" and "inline unconditionally for
> performance", as a documentation issue), but those are the four we
> get.

Does gcc actually follow the "promise"? If that's the case (and if it's
considered a bug when it doesn't), then we can get what Linus wants by
annotating EVERY function with either __always_inline or noinline.

/D 

-- 
Dirk Hohndel
Intel Open Source Technology Center
