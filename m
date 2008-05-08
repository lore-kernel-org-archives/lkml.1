Return-Path: <linux-kernel-owner+w=401wt.eu-S1760917AbYEHTls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760917AbYEHTls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbYEHTlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:41:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44877 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYEHTli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:41:38 -0400
Message-ID: <4823576F.5090607@firstfloor.org>
Date: Thu, 08 May 2008 21:41:35 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBFbHNkw7ZyZmVy?= <michael@elsdoerfer.info>
CC: linux-kernel@vger.kernel.org
Subject: Re: Cannot boot any HIGHMEM kernel (kernel panic - not syncing)
References: <4822DDF1.5010500@elsdoerfer.info> <87od7h9g1s.fsf@basil.nowhere.org> <4822EAC2.5010502@elsdoerfer.info>
In-Reply-To: <4822EAC2.5010502@elsdoerfer.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Elsdörfer wrote:
>>> Now, Machine Check Exception seems to point towards a hardware error,
>>
>> It not only seems to, it does.
>> The non highmem kernel will simply not use most of your memory, so if
>> the machine check happens accessing memory you will not see it.
> 
> Thanks Andi.
> 
> So the problem would be defective RAM in the machine?
> 
> I'm still wondering though while the previous kernel (a self-compiled
> 2.6.17.11) worked then. Laxer checks?

Memory access patterns change between kernels. Likely if you had filled
your memory with some program you would have seen it too.

I always use ftp://ftp.firstfloor.org/pub/ak/memeat.c for testing for
such problems. It simply allocates all free memory and reads and writes
it in a loop.


-Andi


