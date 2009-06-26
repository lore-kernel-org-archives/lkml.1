Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbZFZCE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbZFZCE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 22:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbZFZCEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 22:04:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39746 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbZFZCEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 22:04:48 -0400
Message-ID: <4A442C48.6060308@zytor.com>
Date: Thu, 25 Jun 2009 19:02:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       x86@kernel.org, linux-arch@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, cl@linux-foundation.org
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve
 lpage NUMA support
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <20090625000202.GR6760@one.firstfloor.org> <4A42C131.6040007@zytor.com> <20090625091939.GS6760@one.firstfloor.org> <4A43871F.9030507@zytor.com> <20090625195408.GW6760@one.firstfloor.org> <4A43DAFD.90409@zytor.com> <20090625202642.GX6760@one.firstfloor.org> <4A4418EA.9000705@kernel.org>
In-Reply-To: <4A4418EA.9000705@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Andi Kleen wrote:
>>> I don't know why, but in the configuration I saw each percpu area was
>>> something like 1.8 MB.
>> That sounds like something that needs to be investigated and fixed then.
>> In a sense per cpu space is precious like stack space and shouldn't 
>> be wasted.
> 
> The large percpu space is most likely from lockdep.
> 

That makes sense.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

