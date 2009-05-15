Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZEOLL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZEOLL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 07:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbZEOLLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 07:11:48 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57740 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZEOLLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 07:11:48 -0400
Date: Fri, 15 May 2009 13:11:44 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] Physical Memory Management [0/1]
In-reply-to: <1242385414.26820.55.camel@twins>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       m.szyprowski@samsung.com, kyungmin.park@samsung.com, linux-mm@kvack.org
Message-id: <op.utyxdu2j7p4s8u@amdc030>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.00 (Win32)
References: <op.utu26hq77p4s8u@amdc030>
 <20090513151142.5d166b92.akpm@linux-foundation.org>
 <op.utwwmpsf7p4s8u@amdc030> <1242300002.6642.1091.camel@laptop>
 <op.utw4fdhz7p4s8u@amdc030> <1242302702.6642.1140.camel@laptop>
 <op.utw7yhv67p4s8u@amdc030>
 <20090514100718.d8c20b64.akpm@linux-foundation.org>
 <1242321000.6642.1456.camel@laptop> <op.utyudge07p4s8u@amdc030>
 <20090515101811.GC16682@one.firstfloor.org> <op.utyv89ek7p4s8u@amdc030>
 <1242385414.26820.55.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 2009-05-15 at 12:47 +0200, Michał Nazarewicz wrote:
>> I cannot create a huge page SysV shared memory segment
>> with pages of specified size, can I?

On Fri, 15 May 2009 13:03:34 +0200, Peter Zijlstra wrote:
> Well, hugetlbfs is a fs, so you can simply create a file on there and
> map that shared -- much saner interface than sysvshm if you ask me.

It's not a question of being sane or not, it's a question of whether
X server supports it and it doesn't.  X can read data from Sys V shm
to avoid needles copying (or sending via unix socket or whatever)
pixmaps (or whatever) and so PMM lets it read from continuous blocks
without knowing or carying about it.

-- 
Best regards,                                            _     _
 .o. | Liege of Serenly Enlightened Majesty of         o' \,=./ `o
 ..o | Computer Science,  Michał "mina86" Nazarewicz      (o o)
 ooo +-<m.nazarewicz@samsung.com>-<mina86@jabber.org>-ooO--(_)--Ooo--

