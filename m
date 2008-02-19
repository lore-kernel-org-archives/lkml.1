Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbYBSPz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbYBSPz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756131AbYBSPzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:55:43 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60731 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbYBSPzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:55:41 -0500
Message-ID: <47BAFBBA.7060909@cs.helsinki.fi>
Date: Tue, 19 Feb 2008 17:54:34 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, yanmin_zhang@linux.intel.com
Subject: Re: Linux 2.6.25-rc2
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com> <20080219061107.GA23229@elte.hu> <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com> <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com> <20080219140230.GA32236@Krystal> <84144f020802190621s509dbe7gc8e5609d94aca9b4@mail.gmail.com> <84144f020802190638i4a364d19o8986a457e76ec187@mail.gmail.com> <20080219145554.GE21176@elte.hu> <20080219145719.GA22898@elte.hu>
In-Reply-To: <20080219145719.GA22898@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> If this (or my other patch) indeed solves the problem i'd still favor 
>> a full revert of the SLUB_FASTPATH (commit 1f84260c8ce3b1ce26d4), it 
>> looks quite un-cooked and quite un-tested for multiple independent 
>> reasons.
>>
>> Sigh, why do i again have to be the messenger who brings the bad news 
>> to SLUB land, and again when poor Christoph went on vacation? :-/
> 
> the revert patch is below. (manually done due to other changes since 
> 1f84260c8ce3b1ce26d4 was commited, but trivial)

I am ok with this if someone can actually confirm it fixes things.

			Pekka
