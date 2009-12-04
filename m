Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbZLDPZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbZLDPZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 10:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZLDPZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 10:25:00 -0500
Received: from lucidpixels.com ([75.144.35.66]:39372 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbZLDPZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 10:25:00 -0500
Date: Fri, 4 Dec 2009 10:25:06 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Jiri Kosina <jkosina@suse.cz>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: What is the performance when using frame pointers in the
 kernel?
In-Reply-To: <alpine.LRH.2.00.0912041422360.9567@twin.jikos.cz>
Message-ID: <alpine.DEB.2.00.0912041024500.16957@p34.internal.lan>
References: <alpine.DEB.2.00.0912031235230.6768@p34.internal.lan> <1259868529.3977.1300.camel@laptop> <alpine.LRH.2.00.0912041422360.9567@twin.jikos.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Dec 2009, Jiri Kosina wrote:

> On Thu, 3 Dec 2009, Peter Zijlstra wrote:
>
>>> What is the performance hit when the kernel is compiled with frame
>>> pointers?
>>
>> build both kernels and run your favourite workload to find out.
>
> But generally speaking, frame pointers impose quite some performance
> penalty indeed. lmbench syscall microbenchmark can give you some hint. I
> expect you'll see approx. 10% performance increase for various syscalls if
> you disable them, as that's what we have measured lately.
>
> -- 
> Jiri Kosina
> SUSE Labs, Novell Inc.
>

Thanks for the response.. Good to know.

Justin.
