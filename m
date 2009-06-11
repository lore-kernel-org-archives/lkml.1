Return-Path: <linux-kernel-owner+w=401wt.eu-S1761970AbZFKDtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761970AbZFKDtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 23:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbZFKDtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 23:49:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754005AbZFKDtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 23:49:11 -0400
Date: Wed, 10 Jun 2009 20:49:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [GIT PULL] tracing/urgent for v2.6.31
In-Reply-To: <alpine.DEB.2.00.0906102327050.30552@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.01.0906102045420.6847@localhost.localdomain>
References: <20090610230450.GA8964@elte.hu> <alpine.LFD.2.01.0906102002260.6847@localhost.localdomain> <alpine.DEB.2.00.0906102327050.30552@gandalf.stny.rr.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Jun 2009, Steven Rostedt wrote:
> 
> Well it was:
> 
> 	default y if DEBUG_KERNEL
> 
> Where the rational was that if you want to debug the kernel, you might 
> want to see some tracing features that are available to you.

Sure. I think that FTRACE config is borderline fine, although I think 
tracing is pretty different from the debug options that don't need the 
user to actually do anything (like PAGEALLOC_DEBUG).

It's the other ones I think were clearly dubious (ok, the MARKERS one 
isn't "clearly" dubious, since I have no idea why it got enabled, so I 
guess it would count as "unclearly dubious" then).

			Linus
