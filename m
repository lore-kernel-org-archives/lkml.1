Return-Path: <linux-kernel-owner+w=401wt.eu-S1760832AbZCSU1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760832AbZCSU1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbZCSU1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:27:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752274AbZCSU1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:27:41 -0400
Date: Thu, 19 Mar 2009 13:21:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Ying Han <yinghan@google.com>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
In-Reply-To: <alpine.LFD.2.00.0903190948510.17240@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903191317220.3030@localhost.localdomain>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com> <200903200248.22623.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0903190902000.17240@localhost.localdomain> <200903200334.55710.nickpiggin@yahoo.com.au>
 <alpine.LFD.2.00.0903190948510.17240@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Mar 2009, Linus Torvalds wrote:
> 
> Ahh, so you re-created it? On ext2 only, or is it visible on ext3 as well? 
> I've not even tested - I assumed that I would have to boot into less 
> memory and downgrade my filesystem to ext2, which made me hope somebody 
> else would pick it up first ;)

Oh, btw, can people who see this (Ying Han, Nick and apparently Jan) 
detail their configurations, please? In particular

 - SMP? (CONFIG_SMP and how many cores do you have if so?)

 - PREEMPT (NONE/VOLUNTARY or full preempt?)

 - RCU (CLASSIC/TREE/PREEMPT?)

since those affect the kinds of races we can see a lot.

			Linus
