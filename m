Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbZDOUhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbZDOUhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 16:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbZDOUg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 16:36:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645AbZDOUgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:36:55 -0400
Date: Wed, 15 Apr 2009 13:32:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-Id: <20090415133255.b6a33bfe.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain>
References: <200904140159.n3E1x1K1014705@hera.kernel.org>
	<20090414020544.GA3738@elte.hu>
	<20090415054417.GA5272@elte.hu>
	<200904152014.11717.rusty@rustcorp.com.au>
	<alpine.LFD.2.00.0904150822020.4132@localhost.localdomain>
	<20090415162627.GA32254@elte.hu>
	<alpine.LFD.2.00.0904151013260.4132@localhost.localdomain>
	<49E62BD5.6090508@zytor.com>
	<alpine.LFD.2.00.0904151241490.4132@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 12:43:02 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 15 Apr 2009, H. Peter Anvin wrote:
> > 
> > "cleanup" is indeed the most common, as it is intended to signify a
> > trivial but nonzero code change.  Whether or not it's *correct* is
> > another matter.  "build fix" is valid and proper use: it tells that it
> > fixes a compilation error, which succinctly communicates both the
> > priority of the fix and how it needs to be validated.
> 
> Why would that be "proper use"?
> 
> Dammit, if the "build fix" is not obvious from the rest of the commit 
> message, there's something wrong.
> 
> And if it _is_ obvious, then the mechanical "Impact:" thing is pointless.
> 
> In other words - in neither case does it actually help anything at all. 
> It's only distracting noise.
> 

I'm getting quite a few Impact:s now and I must say that the Impact:
line is always duplicative of the Subject:.  Except in a few cases, and
that's because the Subject: sucked.

But I leave the Impact: lines in there because I'm nice.
