Return-Path: <linux-kernel-owner+w=401wt.eu-S1758292AbZGGUfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbZGGUfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbZGGUfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:35:03 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:59850 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbZGGUfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:35:02 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [patch] perf_counter: Add p6 PMU
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vince@deater.net>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0907071559200.30742@pianoman.cluster.toy>
References: <Pine.LNX.4.64.0907071559200.30742@pianoman.cluster.toy>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 22:34:55 +0200
Message-Id: <1246998895.9777.18.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 16:06 -0400, Vince Weaver wrote:
> OK, so I lied, I found time to throw together a p6 PMU patch.
> I've tested it on a Pentium III and it seems to be working.
> 
> I'm sure the patch still needs a lot of work.  I'm not sure how to 
> implement p6_pmu_enable_all().  There is no support for the various 
> cache-related counters.
> 
> The code is based on the info in the Intel Software Developer's Manual Vol 
> 3B, with some comments and code taken from the relevant perfmon2 patches.
> 
> There's a lot of overlap between the p6, intel, and amd methods.  Not sure 
> if it would be wise to merge up some of the common code.
> 
> I do have Pentium Pro, PII, and PIII hardware to test this on.  I also 
> have a Yonah-based laptop, but it might have architectural perfmon version 
> 1 despite being a p6-related core.
> 
> Let's hope this version of pine I am using doesn't do something stupid to 
> the whitespace in the patch.

Awesome, I'll try it on my pentium-3 mobile tomorrow.

Thanks!

