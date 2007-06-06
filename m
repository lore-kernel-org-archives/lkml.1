Return-Path: <linux-kernel-owner+w=401wt.eu-S1762360AbXFFQxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762360AbXFFQxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbXFFQxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:53:17 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:60446 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbXFFQxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:53:17 -0400
Message-ID: <4666E678.4070608@fr.ibm.com>
Date: Wed, 06 Jun 2007 18:53:12 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Mel Gorman <mel@skynet.ie>
CC: William Lee Irwin III <wli@holomorphy.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, aaw@google.com, a.p.zijlstra@chello.nl
Subject: Re: 2.6.22-rc4-mm1
References: <20070606020737.4663d686.akpm@linux-foundation.org> <4666ABD4.8050402@fr.ibm.com> <4666D050.7010603@googlemail.com> <4666DA55.5090405@fr.ibm.com> <20070606162649.GA9932@skynet.ie> <20070606163538.GN6909@holomorphy.com> <20070606164755.GA14278@skynet.ie>
In-Reply-To: <20070606164755.GA14278@skynet.ie>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On (06/06/07 09:35), William Lee Irwin III didst pronounce:
>> On Wed, Jun 06, 2007 at 05:26:49PM +0100, Mel Gorman wrote:
>>> I do not believe this is Nick's problem. I encountered the same issue and
>>> the bisect ended up here;
>>> # BISECT HERE
>>> mm-variable-length-argument-support.patch
>>> mm-variable-length-argument-support-fix.patch
>>> # BISECT BAD
>>> Reverting those two patches boots ok on my standalone x86 laptop.
>>> Patch authors cc'd. I have not read the patches yet to see what might
>>> be the problem.
>> I found this a while ago and peterz already has a tentative fix for it at
>> http://programming.kicks-ass.net/kernel-patches/max_arg_pages/move_anon_vma.patch
>> I'm sure he himself will chime in with more/better code when he returns.
>>
> 
> This patch also boots successfully on the machine.

Same for me.

thanks,

C.

