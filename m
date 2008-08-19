Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbYHSIEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbYHSIEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbYHSIEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:04:31 -0400
Received: from gw.goop.org ([64.81.55.164]:34607 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987AbYHSIE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:04:29 -0400
Message-ID: <48AA7E8C.8030806@goop.org>
Date: Tue, 19 Aug 2008 01:04:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes
 to use function calls [POST 2]
References: <patchbomb.1219083817@localhost> <20080819004531.GI9914@elte.hu> <20080819073214.GD9807@one.firstfloor.org> <48AA79C4.8060309@goop.org> <20080819074846.GE9807@one.firstfloor.org>
In-Reply-To: <20080819074846.GE9807@one.firstfloor.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Don't pay attention to that number.  It's only the extra latency of a HT
>> context->HT context function call + tlb flush.  Which means 1) the tlb
>> is shared anyway, so the extra flush is redundant, 2) they're not really
>> concurrent, 3) it's going down the single-cpu call, rather than the
>> multi-cpu one, 4) it's only measuring the latency for a particular tlb
>> flush, and doesn't take into account any throughput improvements the
>> extra queueing may add.
>>     
>
> A lot of flushes are synchronous. See the rest of my email that
> you snipped.

Yep, sure, but I just wanted to be clear that the 35% number is almost
useless in isolation, and the first step is to do proper measurements.

    J
