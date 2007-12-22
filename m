Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbXLVCWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbXLVCWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 21:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXLVCV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 21:21:59 -0500
Received: from waste.org ([66.93.16.53]:34777 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbXLVCV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 21:21:58 -0500
Subject: Re: Major regression on hackbench with SLUB (more numbers)
From: Matt Mackall <mpm@selenic.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <p731w9ffu8c.fsf@bingen.suse.de>
References: <20071211143336.GA17866@elte.hu>
	 <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com>
	 <20071221120908.GA15926@elte.hu>
	 <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com>
	 <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com>
	 <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy>
	 <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com>
	 <20071221225413.GA26189@elte.hu>  <p731w9ffu8c.fsf@bingen.suse.de>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 20:19:42 -0600
Message-Id: <1198289982.4411.2.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-22 at 01:28 +0100, Andi Kleen wrote:
> Ingo Molnar <mingo@elte.hu> writes:
> 
> > Christoph, /proc/slabinfo is an _ABI_. You HAVE to provide it. slabtop 
> > relies on it, people use it every day to monitor memory consumption.
> 
> It's definitely not a stable ABI. slabtop tends to exit without any
> error message on any slabinfo version number increase and I've seen
> that happen several times in not so old kernels.
> 
> Requiring just another slabtop update isn't really a big deal.

Might as well mention that SLOB also doesn't provide this functionality,
nor would it make any sense for it to try (because there are no
slab-like objects to report about).

-- 
Mathematics is the supreme nostalgia of our time.

