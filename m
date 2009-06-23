Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbZFWMMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbZFWMMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 08:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757686AbZFWMMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 08:12:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39120 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757685AbZFWMMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 08:12:15 -0400
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [perf] howto switch from pfmon
From: Andi Kleen <andi@firstfloor.org>
References: <4A3FEF75.2020804@inria.fr>
Date: Tue, 23 Jun 2009 14:12:17 +0200
In-Reply-To: <4A3FEF75.2020804@inria.fr> (Brice Goglin's message of "Mon, 22 Jun 2009 22:54:13 +0200")
Message-ID: <87r5xb174u.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brice Goglin <Brice.Goglin@inria.fr> writes:

> Hello,
>
> I am trying to play with perfcounters in current git (actually in latest
> mmotm). I'd like to reproduce what I previously did with pfmon, but I
> couldn't so far.
>
> Something like
>     pfmon --follow-exec 'foobar' -e
> CPU_TO_DRAM_REQUESTS_TO_TARGET_NODE:LOCAL_TO_0,CPU_TO_DRAM_REQUESTS_TO_TARGET_NODE:LOCAL_TO_1
> -- <shell script>
> gives the number of memory accesses to dram node #0 and #1 for all
> processes whose name matches 'foobar'.

My understanding based on recent emails on the topic is that the
perfctr gods decreed you are not to do any of this because they cannot
think of a use case for it, therefore none exist.

-Andi



-- 
ak@linux.intel.com -- Speaking for myself only.
