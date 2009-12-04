Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbZLDNXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbZLDNXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 08:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbZLDNXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 08:23:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbZLDNXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 08:23:50 -0500
Date: Fri, 4 Dec 2009 14:23:55 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Peter Zijlstra <peterz@infradead.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Subject: Re: What is the performance when using frame pointers in the
 kernel?
In-Reply-To: <1259868529.3977.1300.camel@laptop>
Message-ID: <alpine.LRH.2.00.0912041422360.9567@twin.jikos.cz>
References: <alpine.DEB.2.00.0912031235230.6768@p34.internal.lan> <1259868529.3977.1300.camel@laptop>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009, Peter Zijlstra wrote:

> > What is the performance hit when the kernel is compiled with frame 
> > pointers?
> 
> build both kernels and run your favourite workload to find out.

But generally speaking, frame pointers impose quite some performance 
penalty indeed. lmbench syscall microbenchmark can give you some hint. I 
expect you'll see approx. 10% performance increase for various syscalls if 
you disable them, as that's what we have measured lately.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

