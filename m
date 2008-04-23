Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbYDWJZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbYDWJZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbYDWJZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:25:50 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:35427 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYDWJZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:25:49 -0400
Message-ID: <480EFDD3.4020707@aitel.hist.no>
Date: Wed, 23 Apr 2008 11:13:55 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Willy Tarreau <w@1wt.eu>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org> <20080420124717.GH8474@1wt.eu> <20080420132113.GA1899@cs181133002.pp.htv.fi>
In-Reply-To: <20080420132113.GA1899@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> What actually brings bad reputation is shipping a 4k option that is 
> known to break under some circumstances.
>   
How about making 4k stacks incompatible with those circumstances then?
I.e. is you select 4k stacks, then you can't select XFS because we know
that _may_ fail. Similiar for ndiswrapper networking, and other
stuff where problems have been noticed.

Some people don't need any of these, and can then use
safe 4k stacks. Well, at least as safe as the 8k stacks are, there is no
mathematical proof for their safety in all cases either.

Helge Hafting
