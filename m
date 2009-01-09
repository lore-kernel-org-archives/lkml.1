Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbZAIQzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbZAIQzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbZAIQzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:55:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39279 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbZAIQzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:55:31 -0500
Message-ID: <49678095.2030803@zytor.com>
Date: Fri, 09 Jan 2009 08:51:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dirk Hohndel <hohndel@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, jim owens <jowens@hp.com>,
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
References: <20090108141808.GC11629@elte.hu>	<1231426014.11687.456.camel@twins>	<alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>	<1231434515.14304.27.camel@think.oraclecorp.com>	<alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>	<20090108183306.GA22916@elte.hu>	<496648C7.5050700@zytor.com>	<alpine.LFD.2.00.0901081943150.6528@localhost.localdomain>	<20090109130057.GA31845@elte.hu>	<49675920.4050205@hp.com>	<20090109153508.GA4671@elte.hu>	<49677CB1.3030701@zytor.com> <20090109084620.3c711aad@infradead.org>
In-Reply-To: <20090109084620.3c711aad@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dirk Hohndel wrote:
> 
> Does gcc actually follow the "promise"? If that's the case (and if it's
> considered a bug when it doesn't), then we can get what Linus wants by
> annotating EVERY function with either __always_inline or noinline.
> 

__always_inline and noinline does work.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

