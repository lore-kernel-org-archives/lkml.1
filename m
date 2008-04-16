Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbYDPWzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbYDPWzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYDPWzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:55:21 -0400
Received: from ozlabs.org ([203.10.76.45]:36643 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbYDPWzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:55:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18438.33744.389334.543623@cargo.ozlabs.ibm.com>
Date: Thu, 17 Apr 2008 08:55:12 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix find_next_bit breakage on ppc and powerpc
In-Reply-To: <20080416144051.GH24383@elte.hu>
References: <1208191719.12568.1247788911@webmail.messagingengine.com>
	<20080416125724.GC6304@elte.hu>
	<20080416135508.GA16439@mailshack.com>
	<20080416144051.GH24383@elte.hu>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:
> 
> * Alexander van Heukelum <heukelum@mailshack.com> wrote:
> 
> > Powerpc (and ppc) have their have some code in their bitops.h which 
> > used to be exacly the same as asm-generic/bitops/find.h. Include this 
> > header instead.
> > 
> > This should also fix the compile problems due to the generic 
> > find_next_bit changes. Those were fixed by Thomas Gleixner in 
> > asm-generic/bitops/find.h earlier.
> > 
> > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> 
> thanks, applied. I dropped:

Why are powerpc (and ppc) patches
- not being sent to the powerpc maintainer (me)
- not being cc'd to the linuxppc-dev@ozlabs.org list
- ending up going through the x86 tree?

How come patches to unify x86_32 and x86_64 bitops need to end up
touching powerpc?

Paul.
