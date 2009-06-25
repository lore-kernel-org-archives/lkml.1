Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbZFYT1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbZFYT1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbZFYT1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:27:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33061 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZFYT1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:27:21 -0400
Message-ID: <4A43871F.9030507@zytor.com>
Date: Thu, 25 Jun 2009 07:18:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       cl@linux-foundation.org
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve
 lpage NUMA support
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <20090625000202.GR6760@one.firstfloor.org> <4A42C131.6040007@zytor.com> <20090625091939.GS6760@one.firstfloor.org>
In-Reply-To: <20090625091939.GS6760@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>>
>> *Ahem* virtual machines *ahem*...
> 
> And? Even there's not that big typically. 
> 
> The traditional problem was just for 128 NR_CPUs kernel were nothing
> was sized based on machine capacity.
> 
> Also on large systems the VMs shouldn't be sized for full capacity.
> 

We have already have cases where the "possible" CPUs have eaten up the
entire vmalloc area on 32 bits.  In real use.  It's a real problem.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

