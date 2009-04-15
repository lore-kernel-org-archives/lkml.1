Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbZDOTsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbZDOTsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 15:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbZDOTrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 15:47:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756308AbZDOTrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 15:47:48 -0400
Date: Wed, 15 Apr 2009 12:43:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
In-Reply-To: <49E62BD5.6090508@zytor.com>
Message-ID: <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <20090414020544.GA3738@elte.hu> <20090415054417.GA5272@elte.hu> <200904152014.11717.rusty@rustcorp.com.au> <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain> <20090415162627.GA32254@elte.hu>
 <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Apr 2009, H. Peter Anvin wrote:
> 
> "cleanup" is indeed the most common, as it is intended to signify a
> trivial but nonzero code change.  Whether or not it's *correct* is
> another matter.  "build fix" is valid and proper use: it tells that it
> fixes a compilation error, which succinctly communicates both the
> priority of the fix and how it needs to be validated.

Why would that be "proper use"?

Dammit, if the "build fix" is not obvious from the rest of the commit 
message, there's something wrong.

And if it _is_ obvious, then the mechanical "Impact:" thing is pointless.

In other words - in neither case does it actually help anything at all. 
It's only distracting noise.

			Linus
