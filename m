Return-Path: <linux-kernel-owner+w=401wt.eu-S934351AbZLFWbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934351AbZLFWbF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 17:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757683AbZLFWbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 17:31:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47735 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbZLFWbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 17:31:03 -0500
To: Jiri Kosina <jkosina@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Subject: Re: What is the performance when using frame pointers in the kernel?
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.DEB.2.00.0912031235230.6768@p34.internal.lan>
	<1259868529.3977.1300.camel@laptop>
	<alpine.LRH.2.00.0912041422360.9567@twin.jikos.cz>
Date: Sun, 06 Dec 2009 23:31:03 +0100
In-Reply-To: <alpine.LRH.2.00.0912041422360.9567@twin.jikos.cz> (Jiri Kosina's message of "Fri, 4 Dec 2009 14:23:55 +0100 (CET)")
Message-ID: <874oo391lk.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> writes:

> On Thu, 3 Dec 2009, Peter Zijlstra wrote:
>
>> > What is the performance hit when the kernel is compiled with frame 
>> > pointers?
>> 
>> build both kernels and run your favourite workload to find out.
>
> But generally speaking, frame pointers impose quite some performance 
> penalty indeed. lmbench syscall microbenchmark can give you some hint. I 
> expect you'll see approx. 10% performance increase for various syscalls if 
> you disable them, as that's what we have measured lately.

It'll depend on the CPU. On many common cores frame pointer cause
a a few cycles stall on each function entry, but not on all.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
