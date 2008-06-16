Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbYFPSPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbYFPSPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 14:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbYFPSPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 14:15:44 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:41819 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbYFPSPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 14:15:43 -0400
Date: Mon, 16 Jun 2008 19:13:48 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linus Torvalds <torvalds@linux-foundation.or>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Zachary Amsden <zach@vmware.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction abstraction
In-Reply-To: <alpine.LFD.1.10.0806161028080.2949@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0806161906490.19564@blonde.site>
References: <b020e42384197b824320.1213615800@localhost>
 <alpine.LFD.1.10.0806161028080.2949@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008, Linus Torvalds wrote:
> On Mon, 16 Jun 2008, Jeremy Fitzhardinge wrote:
> >
> > ptep_modify_prot_start() returns the current pte value, and puts the
> >   pte entry into a state where either the hardware will not update the
> >   pte, or if it does, the updates will be preserved on commit.
> > 
> > ptep_modify_prot_commit() writes back the updated pte, makes sure that
> >   any hardware updates made since ptep_modify_prot_start() are
> >   preserved.
> 
> Ok, I'm fine with this now that it's renamed to be clearly about just 
> protection bits.
> 
> So 
> 
> 	Acked-by: Linus Torvalds <torvalds@linux-foundation.org>

And seems very reasonable (and exceptionally well described) to me too.

	Acked-by: Hugh Dickins <hugh@veritas.com>
