Return-Path: <linux-kernel-owner+w=401wt.eu-S1764625AbYDXPqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764625AbYDXPqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759328AbYDXPqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:46:25 -0400
Received: from sandeen.net ([209.173.210.139]:23675 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211AbYDXPqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:46:24 -0400
Message-ID: <4810AB56.2030008@sandeen.net>
Date: Thu, 24 Apr 2008 10:46:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Helge Hafting <helge.hafting@aitel.hist.no>
CC: Adrian Bunk <bunk@kernel.org>, Willy Tarreau <w@1wt.eu>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org> <20080420124717.GH8474@1wt.eu> <20080420132113.GA1899@cs181133002.pp.htv.fi> <480EFDD3.4020707@aitel.hist.no>
In-Reply-To: <480EFDD3.4020707@aitel.hist.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helge Hafting wrote:
> Adrian Bunk wrote:
>> What actually brings bad reputation is shipping a 4k option that is 
>> known to break under some circumstances.
>>   
> How about making 4k stacks incompatible with those circumstances then?
> I.e. is you select 4k stacks, then you can't select XFS because we know
> that _may_ fail. Similiar for ndiswrapper networking, and other
> stuff where problems have been noticed.

Problem is, it's the storage configuration (at administration time, not
kernel build time) that matters, too.

I have XFS on Fedora with 4k stacks on SATA /dev/sdb1 on my x86 mythbox,
and it's perfectly fine.  But that's a nice, simple setup.  If I stacked
more things over/under it, I'd be more likely to have trouble.

-Eric
