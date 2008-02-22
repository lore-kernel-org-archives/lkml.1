Return-Path: <linux-kernel-owner+w=401wt.eu-S1763953AbYBVTFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763953AbYBVTFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbYBVTFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:05:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42921 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYBVTFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:05:35 -0500
Message-ID: <47BF1D66.20507@firstfloor.org>
Date: Fri, 22 Feb 2008 20:07:18 +0100
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box
References: <200802210258.45011.yinghai.lu@sun.com>	 <p73hcg189g1.fsf@bingen.suse.de>	 <200802221102.31019.yinghai.lu@sun.com>	 <47BF1BD9.4020808@firstfloor.org> <86802c440802221104m3db0260cj806eb4fbd2a0db82@mail.gmail.com>
In-Reply-To: <86802c440802221104m3db0260cj806eb4fbd2a0db82@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Fri, Feb 22, 2008 at 11:00 AM, Andi Kleen <andi@firstfloor.org> wrote:
>>  > so for that box [4, 0x23] still could be apic clustered? there is a hole [0,3]..
>>
>>  I meant holes between the CPUs only, not including the IO-APICs.
>>
>>
>>  > is their box using AMD cpu or not?
>>
>>  Intel. AMD boxes don't really need clustered mode because they support
>>  bigflat mode.
> 
> So DMI or exclude AMD CPU?

Just check for holes between the cpus as I suggested earlier

-Andi

