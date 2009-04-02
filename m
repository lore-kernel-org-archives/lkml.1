Return-Path: <linux-kernel-owner+w=401wt.eu-S935257AbZDBHWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935257AbZDBHWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbZDBHWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:22:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:33443 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbZDBHWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:22:13 -0400
Message-ID: <49D4679E.4020503@kernel.org>
Date: Thu, 02 Apr 2009 16:22:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: More problems in setup_pcpu_remap()
References: <49D44251.4000606@kernel.org>	<20090401.215233.134215150.davem@davemloft.net>	<49D45364.2010703@kernel.org> <20090402.000703.108386433.davem@davemloft.net>
In-Reply-To: <20090402.000703.108386433.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 07:22:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

David Miller wrote:
>>> Using 2MB per cpu is just rediculious, and really not even necessary.
>> The focus at the moment is using large page for the first chunk to
>> reduce pressure on TLB, not necessarily actually using 2MB for each
>> unit.
> 
> You'll get better TLB hit rates with my suggestion.
> 
> The idea is to carve up a 2MB page amongst consequetive cpus in
> the same NUMA node.
> 
> With hyperthreading these cpus will be sharing the TLB, so you'll
> get better TLB hit rates than the current code.

That sounds great.

> I'm going to do something like this on sparc64.  This x86 code is
> severely demotivating me, so I'll stop looking at it now :-)

Yeah, please go ahead and write severely motivating code.  I'll be
very motivated to apply it to x86.  :-)

Thanks.

-- 
tejun
