Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbZDOQt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbZDOQt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 12:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbZDOQtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 12:49:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35279 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbZDOQtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 12:49:19 -0400
Message-ID: <49E60F7F.4020901@zytor.com>
Date: Wed, 15 Apr 2009 09:46:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <20090414020544.GA3738@elte.hu> <20090415054417.GA5272@elte.hu> <200904152014.11717.rusty@rustcorp.com.au> <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain> <20090415162627.GA32254@elte.hu>
In-Reply-To: <20090415162627.GA32254@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> I got Rusty to use it so i'm to blame for this one. A number of 
> developers/maintainers use it now and they find it useful in a 
> number of circumstances, when used judiciously.
> 
> We are using impact lines to judge "practical impact of a commit". 
> The shorter (while still correct and expressive), the better. We are 
> trying to use it in well-defined cases - but not always.
> 
> Here it helped expose the bogosity of a patch more clearly: the 
> intended impact of "clarifying a confusing API" was not met, and the 
> commit became easier to flame.
> 

It's more than that.

Impact: clarify and extend confusing API

... isn't really an impact as much of an action.  This is part of why
it's kind of bogus in this case.  I'm not particularly blaming Rusty on
that, I personally find it's actually really hard to write Impact:
lines, exactly because it is hard to think about the consequences of a
patch -- and it's even harder when the patch is someone else's.

I generally find I spend about three times longer reviewing the same
amount of code from someone who has written Impact: lines on their
patches, mostly because it means they have thought about it.  It does
get reflected in the rest of the patch.  Also, if they aren't there, I
do end up writing them, and quite often find issues in the process.

Of course, in isolation -- and when wrong -- the Impact: lines look
rather stupid.  However, as part of a bigger workflow we've found that
they actually work, mostly because they do work as a forcing function on
both the maintainer and the submitter.

Nothing is perfect, sadly.  It just does seem to be a net win.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

