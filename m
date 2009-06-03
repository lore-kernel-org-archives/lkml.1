Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbZFCSup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbZFCSup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 14:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbZFCSrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 14:47:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755580AbZFCSrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 14:47:18 -0400
Date: Wed, 3 Jun 2009 11:45:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Larry H." <research@subreption.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change
 ZERO_SIZE_PTR to point at unmapped space)
In-Reply-To: <20090603183939.GC18561@oblivion.subreption.com>
Message-ID: <alpine.LFD.2.01.0906031142390.4880@localhost.localdomain>
References: <20090530230022.GO6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain> <20090531022158.GA9033@oblivion.subreption.com> <alpine.DEB.1.10.0906021130410.23962@gentwo.org> <20090602203405.GC6701@oblivion.subreption.com>
 <alpine.DEB.1.10.0906031047390.15621@gentwo.org> <20090603182949.5328d411@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0906031032390.4880@localhost.localdomain> <20090603180037.GB18561@oblivion.subreption.com> <alpine.LFD.2.01.0906031109150.4880@localhost.localdomain>
 <20090603183939.GC18561@oblivion.subreption.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Jun 2009, Larry H. wrote:
> > 
> > The fact, the NULL pointer attack is neither easy nor common. It's 
> > perfectly reasonable to say "we'll allow mmap at virtual address zero".
> 
> And how could you calibrate if this attack venue isn't easy to take
> advantage of? Or not commonly abused? What empirical results led you to this
> conclusion?

It's not a primary attack vector. You need to have already broken local 
security to get there - you need to be able to execute code.

That means that you've already by-passed all the main security. It's thus 
by definition less common than attack vectors like buffer overflows that 
give you that capability in the first place.

			Linus
