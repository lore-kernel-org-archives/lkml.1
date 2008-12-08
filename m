Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbYLHMCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbYLHMCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 07:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYLHMCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 07:02:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59298
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbYLHMCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 07:02:05 -0500
Date: Mon, 08 Dec 2008 04:02:04 -0800 (PST)
Message-Id: <20081208.040204.139217002.davem@davemloft.net>
To: mingo@elte.hu
Cc: paulus@samba.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       eranian@googlemail.com, dada1@cosmosbay.com, robert.richter@amd.com,
       arjan@infradead.org, hpa@zytor.com, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org
Subject: Re: [patch] Performance Counters for Linux, v2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081208113318.GA14723@elte.hu>
References: <20081208012211.GA23106@elte.hu>
	<18748.37739.383961.318233@drongo.ozlabs.ibm.com>
	<20081208113318.GA14723@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 8 Dec 2008 12:33:18 +0100

> Your whole statistical argument that group readout is a must-have for 
> precision is fundamentally flawed as well: counters _themselves_, as used 
> by most applications, by their nature, are a statistical sample to begin 
> with. There's way too many hardware events to track each of them 
> unintrusively - so this type of instrumentation is _all_ sampling based, 
> and fundamentally so. (with a few narrow exceptions such as single-event 
> interrupts for certain rare event types)

There are a lot of people who are going to fundamentally
disagree with this, myself included.

A lot of things are being stated about what people do with this stuff,
but I think there are people working longer in this area who quite
possibly know a lot better.  But they were blindsided by this new work
instead of being consulted, which was pretty unnice.
