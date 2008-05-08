Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYEHEQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYEHEQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 00:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbYEHEQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 00:16:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbYEHEQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 00:16:14 -0400
Date: Wed, 7 May 2008 21:14:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, steiner@sgi.com,
       holt@sgi.com, npiggin@suse.de, a.p.zijlstra@chello.nl,
       kvm-devel@lists.sourceforge.net, kanojsarcar@yahoo.com,
       rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
In-Reply-To: <20080508034133.GY8276@duo.random>
Message-ID: <alpine.LFD.1.10.0805072109430.3024@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org> <20080507222205.GC8276@duo.random> <20080507153103.237ea5b6.akpm@linux-foundation.org> <20080507224406.GI8276@duo.random> <20080507155914.d7790069.akpm@linux-foundation.org>
 <20080507233953.GM8276@duo.random> <alpine.LFD.1.10.0805071757520.3024@woody.linux-foundation.org> <Pine.LNX.4.64.0805071809170.14935@schroedinger.engr.sgi.com> <20080508025652.GW8276@duo.random> <Pine.LNX.4.64.0805072009230.15543@schroedinger.engr.sgi.com>
 <20080508034133.GY8276@duo.random>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 May 2008, Andrea Arcangeli wrote:
> 
> But removing sort isn't worth it if it takes away ram from the VM even
> when global_mm_lock will never be called.

Andrea, you really are a piece of work. Your arguments have been bogus 
crap that didn't even understand what was going on from the beginning, and 
now you continue to do that.

What exactly "takes away ram" from the VM?

The notion of adding a flag to "struct anon_vma"?

The one that already has a 4 byte padding thing on x86-64 just after the 
spinlock? And that on 32-bit x86 (with less than 256 CPU's) would have two 
bytes of padding if we didn't just make the spinlock type unconditionally 
32 bits rather than the 16 bits we actually _use_?

IOW, you didn't even look at it, did you?

But whatever. I clearly don't want a patch from you anyway, so ..

		Linus
