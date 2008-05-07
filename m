Return-Path: <linux-kernel-owner+w=401wt.eu-S932751AbYEGHpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751AbYEGHpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759314AbYEGHop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:44:45 -0400
Received: from www.tglx.de ([62.245.132.106]:50063 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295AbYEGHon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:44:43 -0400
Date: Wed, 7 May 2008 09:43:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Beulich <jbeulich@novell.com>
cc: odie@cs.aau.dk, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Please revert 709f744 (x86: bitops asm constraint fixes)
In-Reply-To: <482175EF.76E4.0078.0@novell.com>
Message-ID: <alpine.LFD.1.10.0805070940060.3318@apollo.tec.linutronix.de>
References: <1209995129.5172.19.camel@odie.local> <20080506120155.GG32591@elte.hu> <482175EF.76E4.0078.0@novell.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Jan Beulich wrote:
> >>> Ingo Molnar <mingo@elte.hu> 06.05.08 14:01 >>>
> >Jan, any ideas what's wrong with your commit?
> 
> No, I have no idea at all (apart from considering mis-compilation as you
> did. The best path I could suggest is to try and nail this down to one
> (or more, if that happens to be the case) function(s) having been
> changed - this is mostly because part of the changes are really
> tightening things (which therefore I would think ought to be kept),
> while the change to __test_and_change_bit() really weakens things
> (which I nevertheless continue to think is correct and consistent with
> other functions, but which then would be the primary suspect). Of
> course, since no-one else has seen this so far, this would need to be
> done by Simon.
> Once down to a single (hopefully) function, it might be possible to just
> statically compare the two vmlinux-es to perhaps spot whether this
> indeed is mis-compilation.

Jan,

can you please provide a step by step conversion of those constraints
on top of the revert. I'm a bit wary about this whole business as such
constraint problems might hit us elsewhere as well.

Thanks,
	tglx
