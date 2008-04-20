Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbYDTV4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbYDTV4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 17:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbYDTVzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 17:55:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59125 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbYDTVzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 17:55:51 -0400
Message-ID: <480BBBE1.2090406@firstfloor.org>
Date: Sun, 20 Apr 2008 23:55:45 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Arjan van de Ven <arjan@infradead.org>, joern@logfs.org, w@1wt.eu,
       lkml@rtr.ca, bunk@kernel.org, alan@lxorguk.ukuu.org.uk,
       shawn.bohrer@gmail.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: x86: 4kstacks default
References: <20080420085104.GG1595@cs181133002.pp.htv.fi>	<20080420103611.2c0d3519@the-village.bc.nu>	<20080420104444.GI1595@cs181133002.pp.htv.fi>	<87y778aezh.fsf@basil.nowhere.org>	<20080420124717.GH8474@1wt.eu>	<480B44C4.4060104@rtr.ca>	<20080420133857.GB26536@1wt.eu>	<480B50F1.8040309@firstfloor.org>	<20080420164133.GB20694@logfs.org>	<480B7B1E.7010707@firstfloor.org>	<20080420174249.GC20694@logfs.org>	<480B8932.1090308@firstfloor.org>	<20080420115053.7151ef8d@laptopd505.fenrus.org> <20080420145020.217ecdd4.akpm@linux-foundation.org>
In-Reply-To: <20080420145020.217ecdd4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> On Sun, 20 Apr 2008 11:50:53 -0700 Arjan van de Ven <arjan@infradead.org> wrote:
>> On Sun, 20 Apr 2008 20:19:30 +0200
>> Andi Kleen <andi@firstfloor.org> wrote:
>>
>>> In theory if you e.g. convert a recursive algorithm
>>> to iterative you might save some cache foot print, but I don't
>>> think that really happens in kernel code.
>>>
>> this is what Al did for the symlink recursion thing, and Jens did for the block layer...
>> so yes this conversion does happen for real.
> 
> md got mostly-fixed too, via Neil's patch which sat in -mm for nearly two
> years.

Congratulations, you found three examples in 8.4MLOC.

Ok ok I should have said it only happens very rarely (I still stand by
that :)

Anyways it is moot because it was a miscommunication between me and Joerg.

-Andi


