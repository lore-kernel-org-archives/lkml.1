Return-Path: <linux-kernel-owner+w=401wt.eu-S1762733AbXGMCXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762733AbXGMCXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 22:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757078AbXGMCXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 22:23:30 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4985 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756587AbXGMCX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 22:23:29 -0400
Date: Fri, 13 Jul 2007 04:23:43 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
In-Reply-To: <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707130415520.1818@scrub.home>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
 <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random>
 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 11 Jul 2007, Linus Torvalds wrote:

> Sure, bugs happen, but code that everybody runs the same generally doesn't 
> break. So a CPU scheduler doesn't worry me all that much. CPU schedulers 
> are "easy".

A little more advance warning wouldn't have hurt though.
The new scheduler does _a_lot_ of heavy 64 bit calculations without any 
attempt to scale that down a little...
One can blame me now for not having it brought up earlier, but discussions 
with Ingo are not something I'm looking forward to. :(

bye, Roman
