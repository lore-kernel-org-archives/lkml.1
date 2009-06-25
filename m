Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbZFYURY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbZFYURY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 16:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZFYURP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 16:17:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35113 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbZFYURO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 16:17:14 -0400
Message-ID: <4A43DAFD.90409@zytor.com>
Date: Thu, 25 Jun 2009 13:15:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       cl@linux-foundation.org
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve
 lpage NUMA support
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <20090625000202.GR6760@one.firstfloor.org> <4A42C131.6040007@zytor.com> <20090625091939.GS6760@one.firstfloor.org> <4A43871F.9030507@zytor.com> <20090625195408.GW6760@one.firstfloor.org>
In-Reply-To: <20090625195408.GW6760@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> That's hard to believe or a serious bug/misconfiguration somewhere. 
> 
> Each per CPU data should be <100k (let's say 200k with some slack for modules), 
> so to fill vmalloc you would need hundreds of CPUs, which a 32bit
> kernel doesn't really support anyways because it doesn't support
> enough memory for that many CPUs.
> 
> Perhaps you had firmware/hypervisor who passed a gigantic impossible
> value here? If yes thy
> 

I don't know why, but in the configuration I saw each percpu area was
something like 1.8 MB.

	-hpa

