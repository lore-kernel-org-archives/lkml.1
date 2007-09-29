Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbXI2QMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbXI2QMZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 12:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbXI2QMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 12:12:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53552 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754986AbXI2QML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 12:12:11 -0400
Date: Sat, 29 Sep 2007 09:11:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Paul McKenney <paulmck@us.ibm.com>, David Howells <dhowells@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch] i386: remove comment about barriers
In-Reply-To: <20070929132848.GA21169@wotan.suse.de>
Message-ID: <alpine.LFD.0.999.0709290909580.3579@woody.linux-foundation.org>
References: <20070929132848.GA21169@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 29 Sep 2007, Nick Piggin wrote:
> 
> OK this was going to be a quick patch, but after sleeping on it, I think
> it deserves a better analysis... I can prove the comment is incorrect with a
> test program, but I'm not as sure about my thinking that leads me to call it
> also misleading.

You're 100% right, that comment is total crap.

An lfence is *not* a memory barrier, it's just a read memory barrier. 

Although on some microarchitectures they may of course end up being the 
same thing.

			Linus
