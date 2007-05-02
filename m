Return-Path: <linux-kernel-owner+w=401wt.eu-S2992943AbXEBJ2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992943AbXEBJ2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992947AbXEBJ2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:28:04 -0400
Received: from mx1.suse.de ([195.135.220.2]:38083 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992943AbXEBJ2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:28:01 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Juergen Beisert <juergen127@kreuzholzen.de>
Subject: Re: [PATCH] [1/1] CPU-i386-Geode: Chipset access macros do not work as expected (2nd try)
Date: Wed, 2 May 2007 11:25:28 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
References: <200704301409.l3UE9sFg019392@harpo.it.uu.se> <20070501174808.4ac5378b.akpm@linux-foundation.org> <200705020917.00134.juergen127@kreuzholzen.de>
In-Reply-To: <200705020917.00134.juergen127@kreuzholzen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021125.28201.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Most comments states Cyrix CPUs when they are using the macros. Is anything 
> with Cyrix 64 bit relevant? Maybe "include/asm-x86_64/processor.h" is a 
> simple copy of "include/asm-i386/processor.h" and nobody delete the unused 
> macros?

It was originally deleted but later readded when the MTRR code was merged together.
That's because of i386/kernel/cpu/mtrr/state.c which is compiled on x86-64 too.
If you can move that code into cyrix.c it can be removed. Might be a good opportunity
to clean this up.
 
> Please keep me informed and I will resend the patch.

I would need an patch against the current ff tree that doesn't break x86-64.

-Andi
 
