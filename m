Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbZAZXp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbZAZXp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZAZXpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:45:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554AbZAZXpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:45:16 -0500
Date: Mon, 26 Jan 2009 15:44:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: yinghan@google.com, npiggin@suse.de, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, arjan@infradead.org, hpa@zytor.com,
       tglx@linutronix.de, mikew@google.com
Subject: Re: [git pull] cpus4096 tree, part 3
Message-Id: <20090126154427.70e3d594.akpm@linux-foundation.org>
In-Reply-To: <20090126232139.GA29561@elte.hu>
References: <20090103203621.GA2491@elte.hu>
	<20090103213856.GA24138@elte.hu>
	<alpine.LFD.2.00.0901031347570.3179@localhost.localdomain>
	<20090103223723.GA17047@elte.hu>
	<20090105011416.GG32239@wotan.suse.de>
	<20090105011630.GI32239@wotan.suse.de>
	<20090126110054.bdddbf38.akpm@linux-foundation.org>
	<20090126200957.GB13471@elte.hu>
	<20090126124427.6d13f341.akpm@linux-foundation.org>
	<604427e00901261312w23a1f0f5y61fc5c6cc70297fb@mail.gmail.com>
	<20090126232139.GA29561@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 00:21:39 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ying Han <yinghan@google.com> wrote:
> 
> > Thank you Ingo and Andrew for the comments. I will take a look into it 
> > ASAP and updates it here.
> 
> Note, my objection wasnt a hard NAK - just an observation. If all things 
> considered Andrew still favors the VM_FAULT_RETRY approach then that's 
> fine too i guess.
> 
> It's just that a quick look gave me the feeling of a retry flag tacked on 
> to an existing codepath [and all the micro-overhead and complexity that 
> this brings], instead of a clean refactoring of pagefault handling 
> functionality into a higher MM level retry loop.
> 
> So the alternative has to be looked at and rejected because it's 
> technically inferior - not because it's more difficult to implement. 
> (which it certainly is)
> 

I have wobbly feelings about this patch.  There are your issues, and a
long string of problems and fixes.  And my recent half-assed
linux-next-related fix which I didn't really think about.

It all needs a revisit/rereview/reunderstand cycle.
