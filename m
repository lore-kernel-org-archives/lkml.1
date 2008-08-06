Return-Path: <linux-kernel-owner+w=401wt.eu-S1764069AbYHFDdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764069AbYHFDdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 23:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYHFDdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 23:33:36 -0400
Received: from gw.goop.org ([64.81.55.164]:42868 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbYHFDdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 23:33:35 -0400
Message-ID: <48991B84.2080704@goop.org>
Date: Tue, 05 Aug 2008 20:33:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 8] x86/smp function calls: convert x86 tlb flushes
 to use function calls
References: <patchbomb.1217636085@localhost> <87k5eu6d4f.fsf@basil.nowhere.org>
In-Reply-To: <87k5eu6d4f.fsf@basil.nowhere.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
>   
>> 1. use smp_call_function_mask to implement cross-cpu TLB flushes
>>     
>
>
> Do you have any measurements comparing performance of the old and 
> the new call? TLB flush is quite time critical so we should be very
> careful here.

No.  What benchmark would you suggest?

    J

