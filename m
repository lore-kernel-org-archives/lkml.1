Return-Path: <linux-kernel-owner+w=401wt.eu-S1760803AbXLVA2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760803AbXLVA2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 19:28:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbXLVA2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 19:28:38 -0500
Received: from ns.suse.de ([195.135.220.2]:59658 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbXLVA2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 19:28:38 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
From: Andi Kleen <andi@firstfloor.org>
References: <20071211143336.GA17866@elte.hu>
	<Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
	<Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com>
	<20071221120908.GA15926@elte.hu>
	<Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com>
	<alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org>
	<Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com>
	<1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy>
	<Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com>
	<20071221225413.GA26189@elte.hu>
Date: Sat, 22 Dec 2007 01:28:35 +0100
In-Reply-To: <20071221225413.GA26189@elte.hu> (Ingo Molnar's message of "Fri\, 21 Dec 2007 23\:54\:13 +0100")
Message-ID: <p731w9ffu8c.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> Christoph, /proc/slabinfo is an _ABI_. You HAVE to provide it. slabtop 
> relies on it, people use it every day to monitor memory consumption.

It's definitely not a stable ABI. slabtop tends to exit without any
error message on any slabinfo version number increase and I've seen
that happen several times in not so old kernels.

Requiring just another slabtop update isn't really a big deal.

Also it's not that it's a critical functionality like udev.

-Andi

