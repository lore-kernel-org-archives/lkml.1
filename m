Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbYFPRgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbYFPRgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 13:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbYFPRgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 13:36:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751035AbYFPRgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 13:36:22 -0400
Date: Mon, 16 Jun 2008 10:29:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Zachary Amsden <zach@vmware.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction
 abstraction
In-Reply-To: <b020e42384197b824320.1213615800@localhost>
Message-ID: <alpine.LFD.1.10.0806161028080.2949@woody.linux-foundation.org>
References: <b020e42384197b824320.1213615800@localhost>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 16 Jun 2008, Jeremy Fitzhardinge wrote:
>
> ptep_modify_prot_start() returns the current pte value, and puts the
>   pte entry into a state where either the hardware will not update the
>   pte, or if it does, the updates will be preserved on commit.
> 
> ptep_modify_prot_commit() writes back the updated pte, makes sure that
>   any hardware updates made since ptep_modify_prot_start() are
>   preserved.

Ok, I'm fine with this now that it's renamed to be clearly about just 
protection bits.

So 

	Acked-by: Linus Torvalds <torvalds@linux-foundation.org>

for what it's worth.

		Linus
