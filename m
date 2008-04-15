Return-Path: <linux-kernel-owner+w=401wt.eu-S1760120AbYDOHrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120AbYDOHrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757861AbYDOHrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:47:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50552 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbYDOHq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:46:58 -0400
Message-ID: <48045D6C.1010508@firstfloor.org>
Date: Tue, 15 Apr 2008 09:46:52 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 2/2] bootmem: Node-setup agnostic free_bootmem()
References: <20080412223319.372887160@symbol.fehenstaub.lan>	<20080412225850.704752615@symbol.fehenstaub.lan>	<87lk3hwv52.fsf@basil.nowhere.org> <20080414232308.ffa4e269.akpm@linux-foundation.org>
In-Reply-To: <20080414232308.ffa4e269.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 13 Apr 2008 18:56:57 +0200 Andi Kleen <andi@firstfloor.org> wrote:
> 
>> Johannes Weiner <hannes@saeurebad.de> writes:
>>
>>> Make free_bootmem() look up the node holding the specified address
>>> range which lets it work transparently on single-node and multi-node
>>> configurations.
>> Acked-by: Andi Kleen <andi@firstfloor.org>
>>
>> This is far better than the original change it replaces and which 
>> I also objected to in review.
>>
> 
> So...  do we think these two patches are sufficiently safe and important for
> 2.6.25?

It's only strictly needed for .26 I think for some (also slightly
dubious) changes queued in git-x86.

-Andi


