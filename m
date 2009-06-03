Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbZFCSwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbZFCSwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 14:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbZFCSvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 14:51:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754550AbZFCSvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 14:51:53 -0400
Date: Wed, 3 Jun 2009 11:50:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Larry H." <research@subreption.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change
 ZERO_SIZE_PTR to point at unmapped space)
In-Reply-To: <alpine.LFD.2.01.0906031142390.4880@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906031145460.4880@localhost.localdomain>
References: <20090530230022.GO6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain> <20090531022158.GA9033@oblivion.subreption.com> <alpine.DEB.1.10.0906021130410.23962@gentwo.org> <20090602203405.GC6701@oblivion.subreption.com>
 <alpine.DEB.1.10.0906031047390.15621@gentwo.org> <20090603182949.5328d411@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0906031032390.4880@localhost.localdomain> <20090603180037.GB18561@oblivion.subreption.com> <alpine.LFD.2.01.0906031109150.4880@localhost.localdomain>
 <20090603183939.GC18561@oblivion.subreption.com> <alpine.LFD.2.01.0906031142390.4880@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Jun 2009, Linus Torvalds wrote:
> 
> That means that you've already by-passed all the main security. It's thus 
> by definition less common than attack vectors like buffer overflows that 
> give you that capability in the first place.

Btw, you obviously need to then _also_ pair it with some as-yet-unknown 
case of kernel bug to get to that NULL pointer (or zero-sized-alloc 
pointer) problem. 

You _also_ seem to be totally ignoring the fact that we already _do_ 
protect against NULL pointers by default.

So I really don't see why you're making a big deal of this. It's as if you 
were talking about us not randomizing the address space - sure, you can 
turn it off, but so what? We do it by default.

So it boils down to:

 - NULL pointers already cannot be in mmap memory (unless a distro has 
   done something wrong - outside of the kernel)

 - What's your beef? Let it go, man.

			Linus
