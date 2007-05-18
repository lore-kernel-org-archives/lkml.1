Return-Path: <linux-kernel-owner+w=401wt.eu-S1762971AbXERXTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762971AbXERXTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 19:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755952AbXERXSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 19:18:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38240 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755365AbXERXSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 19:18:53 -0400
Date: Fri, 18 May 2007 16:15:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org, malitzke@metronets.com
Subject: Re: [Bug 8501] udivdi3  absence with gcc-4.3.0 on kernels 2.6.20.11
 & 2.6.22.-rc1
In-Reply-To: <20070518152935.b5a4b3bf.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0705181613530.3890@woody.linux-foundation.org>
References: <200705181941.l4IJfOtf018049@fire-2.osdl.org>
 <20070518152935.b5a4b3bf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 May 2007, Andrew Morton wrote:
> 
> gcc-4.3 appears to have cunningly converted this:

Very cunning indeed.

Considerign that gcc converted straightforward and simple code to a total 
disaster with a 64-bit divide, I'd call it a gcc bug.

> into a divide-by-1000000000 operation, so it emits a call to udivdi3 and we
> don't link.

I think the proper fix is to just tell people that version of gcc is 
broken.

		Linus
