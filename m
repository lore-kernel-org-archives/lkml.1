Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbZFYACT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbZFYACT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 20:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755091AbZFYACF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 20:02:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34115 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbZFYACE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 20:02:04 -0400
Date: Thu, 25 Jun 2009 02:02:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
       hpa@zytor.com, tglx@linutronix.de, cl@linux-foundation.org
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve lpage NUMA support
Message-ID: <20090625000202.GR6760@one.firstfloor.org>
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624165508.30b88343.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I assume from the tremendous number of for_each_possible_cpu()s that
> CPU hotplug awareness won't be happening.
> 
> Do we have a feeling for the amount of wastage here?  If
> 
> 	num_possible_cpus() - num_online_cpus() == N

Haven't read the new patches, but per cpu data always was sized
for all possible CPUs.

> and N is large, what did it cost?

> And what are reasonable values of N?

N should normally not be large anymore, since num_possible_cpus() 
is sized based on firmware information now.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
