Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbYFTUF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbYFTUF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbYFTUFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:05:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753218AbYFTUFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:05:15 -0400
Date: Fri, 20 Jun 2008 13:03:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, benh@kernel.crashing.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel <kvm-devel@lists.sourceforge.net>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Hugh Dickins <hugh@veritas.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction
 abstraction
In-Reply-To: <20080620195620.GA20183@elte.hu>
Message-ID: <alpine.LFD.1.10.0806201302350.3167@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0806181723400.2907@woody.linux-foundation.org> <4859AA47.2020903@goop.org> <alpine.LFD.1.10.0806181743390.2907@woody.linux-foundation.org> <alpine.LFD.1.10.0806182050470.2907@woody.linux-foundation.org> <20080619115832.GM15228@elte.hu>
 <alpine.LFD.1.10.0806190928100.2907@woody.linux-foundation.org> <20080619164708.GA32190@elte.hu> <20080620101028.GA23664@elte.hu> <485BFFC4.3070902@goop.org> <alpine.LFD.1.10.0806201211560.3167@woody.linux-foundation.org> <20080620195620.GA20183@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 20 Jun 2008, Ingo Molnar wrote:
> 
> okay - Jeremy, could you try the fix below? (or tip/master, i just 
> pushed this out)

Actually, don't try that one.

It needs to be a _byte_ registers, so "ir" was wrong. You need "iq".

		Linus
