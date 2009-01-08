Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbZAHOVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbZAHOVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZAHOVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:21:44 -0500
Received: from styx.suse.cz ([82.119.242.94]:36912 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751031AbZAHOVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:21:43 -0500
Date: Thu, 8 Jan 2009 15:21:41 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
cc: Adam Osuchowski <adwol@zonk.pl>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Subject: Re: Is 386 processor still supported?
In-Reply-To: <1231424025.11687.447.camel@twins>
Message-ID: <alpine.LNX.1.10.0901081518070.5377@jikos.suse.cz>
References: <20090108120338.6b8b4567@zonk.pl>  <alpine.LRH.1.10.0901081359520.24105@twin.jikos.cz> <1231424025.11687.447.camel@twins>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2009, Peter Zijlstra wrote:

> > Subject: x86: make spinlocks available on machines without xadd insn
> > Current kernel wouldn't compile on ancient x86 machines that don't support 
> > xadd instruction, as ticket spinlocks implementation unconditionally uses 
> > it.
> > On machines without CONFIG_X86_XADD, use old-style byte spinlock 
> > implementation instead.
> afaik we don't support i386-smp and up spinlocks are trivial
> preempt_disable() calls.

Hmm. Where in Kconfig is SMP for M386 not allowed?

-- 
Jiri Kosina
SUSE Labs
