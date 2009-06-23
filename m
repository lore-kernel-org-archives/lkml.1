Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbZFWMXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbZFWMXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 08:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZFWMXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 08:23:15 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:52269 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbZFWMXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 08:23:14 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [perf] howto switch from pfmon
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Brice Goglin <Brice.Goglin@inria.fr>, paulus@samba.org, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <87r5xb174u.fsf@basil.nowhere.org>
References: <4A3FEF75.2020804@inria.fr>  <87r5xb174u.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 14:23:20 +0200
Message-Id: <1245759800.19816.1712.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 14:12 +0200, Andi Kleen wrote:
> Brice Goglin <Brice.Goglin@inria.fr> writes:
> 
> > Hello,
> >
> > I am trying to play with perfcounters in current git (actually in latest
> > mmotm). I'd like to reproduce what I previously did with pfmon, but I
> > couldn't so far.
> >
> > Something like
> >     pfmon --follow-exec 'foobar' -e
> > CPU_TO_DRAM_REQUESTS_TO_TARGET_NODE:LOCAL_TO_0,CPU_TO_DRAM_REQUESTS_TO_TARGET_NODE:LOCAL_TO_1
> > -- <shell script>
> > gives the number of memory accesses to dram node #0 and #1 for all
> > processes whose name matches 'foobar'.
> 
> My understanding based on recent emails on the topic is that the
> perfctr gods decreed you are not to do any of this because they cannot
> think of a use case for it, therefore none exist.

I wouldn't put it like that.

But we haven't gotten around to implementing uncore pmu stuff --
assuming that is what was meant.

What would be accurate is to say that we think uncore is a lot less
interesting that a lot of other pmu features.

