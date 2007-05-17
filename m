Return-Path: <linux-kernel-owner+w=401wt.eu-S1760142AbXEQCXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142AbXEQCXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 22:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbXEQCXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 22:23:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38227 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754880AbXEQCXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 22:23:17 -0400
Date: Wed, 16 May 2007 19:21:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christian <haveaniceday@cv-sv.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
In-Reply-To: <464BAF07.9020003@cv-sv.de>
Message-ID: <alpine.LFD.0.98.0705161920410.3890@woody.linux-foundation.org>
References: <464B9D2C.7040704@cv-sv.de> <alpine.LFD.0.98.0705161750350.3890@woody.linux-foundation.org>
 <464BAF07.9020003@cv-sv.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 May 2007, Christian wrote:

> Linus Torvalds wrote:
> > Can you check? The Nehemian (C3-2) should be model 9 or greater.
> 
> Yes, it's a Nehemiah

Ok. If so, we should blacklist both MCYRIXIII and MVIAC3_2, I suspect.

> lola:~ # cat /proc/cpuinfo
> flags           : fpu vme de pse tsc msr cx8 sep mtrr pge cmov pat mmx fxsr sse rng rng_en ace ace_en

However, it does seem to *claim* to support "cx8" aka cmpxchg8b. What's up 
with that?

		Linus
