Return-Path: <linux-kernel-owner+w=401wt.eu-S1765589AbYEFJca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765589AbYEFJca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbYEFJcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:32:20 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:53705 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755022AbYEFJcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:32:19 -0400
Message-ID: <482025D9.9010503@seznam.cz>
Date: Tue, 06 May 2008 11:33:13 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, arnd@arndb.de,
       linux-arch@vger.kernel.org, John Linn <linnj@xilinx.com>,
       matthew@wil.cx, will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Microblaze: implement dma-coherent API andrefactorcache
 flush code.
References: <20080505223706.1236C1C8004E@mail131-sin.bigfish.com> <1210028237.5798.121.camel@localhost> <20080505231206.922A61C780C0@mail19-wa4.bigfish.com> <1210032899.5798.179.camel@localhost> <20080506003104.4717D19B8050@mail213-sin.bigfish.com> <Pine.LNX.4.64.0805060923100.3160@anakin>
In-Reply-To: <Pine.LNX.4.64.0805060923100.3160@anakin>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John, Steve and others,

I'll only rename flush to invalidate. Thant's all for now.

Michal

> On Mon, 5 May 2008, Stephen Neuendorffer wrote:
>>> -----Original Message-----
>>> From: John Williams [mailto:john.williams@petalogix.com]
>>>
>>> Sure - what I meant is can dma_alloc just call kmalloc to do it's
>> work?
>>
>> I scanned through Linux Device Drivers, and it appears that calling
>> get_free_pages is:
>> 1) more efficient than kmalloc for large allocations
>> 2) allocates physically contiguous memory, which kmalloc doesn't
>> necessarily do if there's an mmu.
> 
> kmalloc() allocates physically contiguous memory, vmalloc() doesn't.
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
> 
> 

