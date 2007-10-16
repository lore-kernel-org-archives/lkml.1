Return-Path: <linux-kernel-owner+w=401wt.eu-S934249AbXJPPqC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249AbXJPPqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 11:46:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933409AbXJPPpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 11:45:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58871 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933390AbXJPPpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 11:45:50 -0400
Message-ID: <4714DBD7.7080706@zytor.com>
Date: Tue, 16 Oct 2007 08:42:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
CC: Arjan van de Ven <arjan@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LFENCE instruction
References: <Pine.LNX.4.64.0710152204060.30307@artax.karlin.mff.cuni.cz> <20071015143732.01d99af8@laptopd505.fenrus.org> <Pine.LNX.4.64.0710160004500.2604@artax.karlin.mff.cuni.cz> <471401AF.4090802@zytor.com> <Pine.LNX.4.64.0710161205160.1315@artax.karlin.mff.cuni.cz>
In-Reply-To: <Pine.LNX.4.64.0710161205160.1315@artax.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka wrote:
> On Mon, 15 Oct 2007, H. Peter Anvin wrote:
> 
>> Mikulas Patocka wrote:
>>> I know about unordered stores (movnti & similar) --- they basically use
>>> write-combining method on memory that is normally write-back --- and they
>>> need sfence. But which one instruction does unordered load and needs
>>> lefence?
>>>
>> PREFETCHNTA.
> 
> PREFETCH* doesn't change program semantics. The processor is allowed to 
> ignore prefetch instruction if it doesn't have resources needed for 
> prefetch. It not ordered wrt. fences.
> 
> PREFETCHNTA was implemented as prefetch into L1 cache and omitting L2 
> cache on Pentium 3 and M --- and it is implemented as prefetch into L2 
> cache on other --- do it doesn't really use any special buffers.
> 

It's semantics allows it to, though.  It's not clear to me whether it is 
actually necessary on existing chips.

It does, I believe, way-restricted prefetch on existing silicon.

	-hpa
