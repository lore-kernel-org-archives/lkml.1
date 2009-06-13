Return-Path: <linux-kernel-owner+w=401wt.eu-S1761278AbZFMU0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278AbZFMU0O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 16:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759897AbZFMU0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 16:26:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753916AbZFMUZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 16:25:59 -0400
Date: Sat, 13 Jun 2009 13:25:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Paul Mackerras <paulus@samba.org>
cc: benh@kernel.crashing.org, akpm@linux-foundation.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib: Provide generic atomic64_t implementation
In-Reply-To: <alpine.LFD.2.01.0906131312470.3237@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906131323270.3237@localhost.localdomain>
References: <18995.20685.227683.561827@cargo.ozlabs.ibm.com> <alpine.LFD.2.01.0906131312470.3237@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 13 Jun 2009, Linus Torvalds wrote:
> 
> On Sat, 13 Jun 2009, Paul Mackerras wrote:
> >
> > Linus, Andrew: OK if this goes in via the powerpc tree?
> 
> Ok by me.

Btw, do 32-bit architectures really necessarily want 64-bit performance 
counters? 

I realize that 32-bit counters will overflow pretty easily, but I do 
wonder about the performance impact of doing things like hashed spinlocks 
for 64-bit counters. Maybe the downsides of 64-bit perf counters on such 
architectures might outweight the upsides?

		Linus
