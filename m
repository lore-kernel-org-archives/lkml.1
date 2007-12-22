Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbXLVTpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbXLVTpe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 14:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbXLVTpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 14:45:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57758 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbXLVTpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 14:45:24 -0500
Date: Sat, 22 Dec 2007 20:46:20 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: slabtop replacement was Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071222194620.GA19350@one.firstfloor.org>
References: <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com> <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org> <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com> <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy> <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com> <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de> <20071222100326.GF26157@elte.hu> <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As a followup to the thread regarding slabinfo and Andrew's 
earlier query about updating slabtop.
 
watch -n1 slabinfo -S 

seems to be a reasonable replacement for slabtop. The only
missing functionality are some hotkeys missing: you have to restart 
now to get a different sort order (and to read the slabinfo source
to find out the correct option), but other than that it works.

So I would propose to just retire slabtop and replace 
it with a simple shell script doing that.

A manpage for slabinfo would be useful though. Anybody 
volunteering to write one? 

-Andi


