Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbZHFPiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbZHFPiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbZHFPiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:38:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:48634 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbZHFPiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:38:15 -0400
Subject: Re: [perf/rc5] oops running perf record -s with multiple -e
From: Peter Zijlstra <peterz@infradead.org>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A7A7778.7000000@inria.fr>
References: <4A7A7778.7000000@inria.fr>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Aug 2009 17:38:00 +0200
Message-Id: <1249573080.32113.547.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 08:26 +0200, Brice Goglin wrote:
> Hello Ingo
> 
> I finally managed to test the threaded perfcounter statistics (thanks a
> lot for implementing it). I am running 2.6.31-rc5 (with the AMD
> magny-cours patches but I don't think they matter here). I am trying to
> measure local/remote memory accesses per thread during the well-known
> stream benchmark. It's compiled with OpenMP using 16 threads on a
> quad-socket quad-core barcelona machine.
> 
> Command line is:
>  /mnt/scratch/bgoglin/cpunode/linux-2.6.31/tools/perf/perf record -f -s
> -e r1000001e0 -e r1000002e0 -e r1000004e0 -e r1000008e0 ./stream
> 
> It seems to work fine with a single -e <counter> on the command line
> while it crashes when there are at least 2 of them.
> It seems to work fine without -s as well.

OK, I can reproduce OOPSen this way, got me baffled though.

I'll prod at it some...
