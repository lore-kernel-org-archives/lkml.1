Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbZAMBHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbZAMBHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbZAMBG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:06:58 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:41915 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757236AbZAMBG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:06:57 -0500
Date: Tue, 13 Jan 2009 01:06:55 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <peterz@infradead.org>,
       Jiri Kosina <jkosina@suse.cz>, Adam Osuchowski <adwol@zonk.pl>,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Is 386 processor still supported?
In-Reply-To: <20090108151046.GK18120@elte.hu>
Message-ID: <alpine.LFD.1.10.0901130047160.10547@ftp.linux-mips.org>
References: <20090108120338.6b8b4567@zonk.pl> <alpine.LRH.1.10.0901081359520.24105@twin.jikos.cz> <1231424025.11687.447.camel@twins> <alpine.LNX.1.10.0901081518070.5377@jikos.suse.cz> <1231424833.11687.452.camel@twins> <20090108150448.2393aeb0@lxorguk.ukuu.org.uk>
 <20090108151046.GK18120@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2009, Ingo Molnar wrote:

> > So our minimal spec for SMP is probably 486DX + external Intel APIC.
> > 
> > In practice I doubt there is a single Intel APIC type 486 SMP box on the 
> > planet running Linux (or quite possibly running at all)
> 
> yeah, that's very likely true. I think we could eliminate some of the SMP 
> complications by requiring cmpxchg presence for CONFIG_SMP, agreed?

 I failed to track down a single 486 SMP system that would adhere to the 
MP spec.  There were and possibly still are APIC-based 486 SMP systems out 
there, but most likely they are not Intel MPS-compliant, by not providing 
the MP header at the very least.  Thus Linux would have to be ported and I 
gather the interest in doing so is epsilon.

 Myself, I could not resist trying an APIC-based 486 SMP box and possibly 
fixing issues if I found one and it was MPS-compliant, but nothing beyond 
that I would say.  Life's too short.

  Maciej
