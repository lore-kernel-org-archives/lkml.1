Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbYGWAL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbYGWAL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 20:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYGWALt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 20:11:49 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63222 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751768AbYGWALs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 20:11:48 -0400
Date: Wed, 23 Jul 2008 01:10:54 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>
cc: Chuck Ebbert <cebbert@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: PIC, L-APIC and I/O APIC debug information
In-Reply-To: <18564.38760.212333.375520@harpo.it.uu.se>
Message-ID: <Pine.LNX.4.55.0807230053460.31850@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0807202226310.24038@cliff.in.clinika.pl>
 <18563.55832.673541.202465@harpo.it.uu.se> <Pine.LNX.4.55.0807211222250.23386@cliff.in.clinika.pl>
 <18564.38760.212333.375520@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008, Mikael Pettersson wrote:

> It's not even remotely C-like, which will cause confusion
> for anyone or anything trying to read and understand the code.

 Not being C-like sounds like an advantage as the reader would be forced 
to check what it really means, but I can see what you mean, and the fact 
we have got worse constructs elsewhere does not look like a terribly good 
argument either.

> Something like the following looks saner to me, would it work for you?
> 
> 	#ifdef debug
> 	#define apicdebug	/* empty */
> 	#define __apicinit	/* empty */
> 	#else
> 	#define apicdebug	static
> 	#define __apicinit	__init
> 	#endif
> 	...
> 	apicdebug void __apicinit print_IO_APIC(void)
> 	{ .. }

 Hmm, suddenly out of a single line, quite a lot of stuff has emerged.  I 
am not convinced and I am now thinking of something else instead.

 However these debugging facilities are not absolutely necessary for the
essential functionality of the patch, so I will simply remove them for
reconsideration and send a regenerated patch containing the rest only.

 Ingo, please drop this one from anywhere you may have it -- I will send a 
replacement shortly.

  Maciej
