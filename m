Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbYGLXF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbYGLXF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 19:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYGLXFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 19:05:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417AbYGLXFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 19:05:16 -0400
Date: Sat, 12 Jul 2008 16:04:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Paul Menage <menage@google.com>, Max Krasnyansky <maxk@qualcomm.com>,
       Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       miaox@cn.fujitsu.com, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
In-Reply-To: <19f34abd0807121600l653e28bfwb5cce2d880b7f2cd@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0807121603150.2959@woody.linux-foundation.org>
References: <20080712031736.GA3040@damson.getinternet.no>  <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>  <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>  <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org> 
 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>  <alpine.LFD.1.10.0807121504010.2959@woody.linux-foundation.org> <19f34abd0807121600l653e28bfwb5cce2d880b7f2cd@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 Jul 2008, Vegard Nossum wrote:
> 
> (A little pet horse for the occasion: Testing can show the presence of
> errors, but not their absence. But that's a different story.)

Absolutely. Which is actually why I prefer my patch. I think it fixes - in 
general - the issue of CPU migration migrating tasks back to the CPU that 
we're taking down.

The other patches seem to work around just the problem that _triggers_ the 
bug. They don't actually make it impossible to migrate to a CPU that is 
getting shut down - they just try to avoid the particular sequence that 
made it happen for you.

			Linus
