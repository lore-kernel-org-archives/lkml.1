Return-Path: <linux-kernel-owner+w=401wt.eu-S1161773AbXEAUwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161773AbXEAUwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161764AbXEAUwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:52:11 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:43897 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161757AbXEAUll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:41:41 -0400
Message-ID: <4637A5EA.80206@cosmosbay.com>
Date: Tue, 01 May 2007 22:41:14 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Bill Irwin <bill.irwin@oracle.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [30/30] x86_64: Add missing !X86_PAE dependincy to the
 2G/2G split.
References: <20070501557.815359000@suse.de>	<20070501035829.1C93D13CAF@wotan.suse.de> <4636C16F.204@cosmosbay.com>	<20070501062132.GQ25929@bingen.suse.de>	<20070501130132.GL26598@holomorphy.com>	<46376210.6090200@cosmosbay.com>	<20070501170046.GO26598@holomorphy.com> <m1d51kzcnr.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1d51kzcnr.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 01 May 2007 22:41:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman a écrit :
> Bill Irwin <bill.irwin@oracle.com> writes:
> 
>> Only 1GB-aligned kernel/user splits are now handled for PAE. The
>> 2GB/2GB split attempts to avoid aliasing vmallocspace with the 1:1
>> mapping for physical memory by using an actual split of 1.875/2.125
>> to accommodate 128MB of vmallocspace out of what would otherwise
>> be a full 2GB for userspace. That attempt disturbs the alignment
>> required by PAE for 2GB/2GB splits, and furthermore does not provide
>> a 2GB/2GB split as advertised.
>>
>> This patch resolves the issues here in two manners. The first is
>> by providing a true 2GB/2GB split in addition to the 1.875/2.125
>> split. The second is by renaming the 1.875/2.125 split to
>> CONFIG_VMSPLIT_2G_OPT analogously to CONFIG_VMSPLIT_3G_OPT, which
>> performs a similar manuever to avoid aliasing vmallocspace with
>> the 1:1 mapping for physical memory around the 3GB boundary. With
>> the 1.875/2.125 split properly-named, its config option is then
>> tagged as depending on !HIGHMEM to express the PAE implementation's
>> current inability to deal with such unaligned splits.
>>
>> This patch is essentially a combination of two patches, one written
>> by Eric Biederman and the other by Eric Dumazet. If they could add
>> their Signed-off-by: to this, I'd be much obliged.
>>
>> Signed-off-by: William Irwin <wli@holomorphy.com>
>> Cc: Eric Dumazet <dada1@cosmosbay.com>
>> Cc: Mark Lord <lkml@rtr.ca>
>> Cc: Eric W. Biederman <ebiederm@xmission.com>
>> Cc: Andi Kleen <ak@suse.de>
> 
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Eric Dumazet <dada1@cosmosbay.com>
