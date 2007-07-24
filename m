Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbXGXVrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbXGXVrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbXGXVrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:47:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41233 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752901AbXGXVrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:47:11 -0400
Date: Tue, 24 Jul 2007 14:46:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Andi Kleen <andi@firstfloor.org>, Trent Piepho <xyzzy@speakeasy.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
 unnecessarily
In-Reply-To: <46A66F9E.1030509@goop.org>
Message-ID: <alpine.LFD.0.999.0707241444040.3607@woody.linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
 <46A578A1.5010504@yahoo.com.au> <Pine.LNX.4.64.0707241154060.1433@cselinux1.cse.iitk.ac.in>
 <46A5A929.4020706@yahoo.com.au> <Pine.LNX.4.58.0707240058370.30561@shell4.speakeasy.net>
 <alpine.LFD.0.999.0707241236020.3607@woody.linux-foundation.org>
 <p73myxlsfl4.fsf@bingen.suse.de> <alpine.LFD.0.999.0707241304560.3607@woody.linux-foundation.org>
 <46A66F9E.1030509@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jul 2007, Jeremy Fitzhardinge wrote:
> >
> > But gcc docs also talk about the other things volatile means, including 
> > "not significantly moved".
> 
> Actually, it doesn't.  In fact it goes out of its way to say that "asm
> volatile" statements can be moved quite a bit, with respect to other
> asms, other code, jumps, basic blocks, etc.

Ahh. That's newer.

Historically, gcc manuals used to say "may not be deleted or significantly 
reordered".

So they've weakened what it means, probably exactly because it wasn't 
well-defined before either.

		Linus
