Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbZEOLEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbZEOLEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 07:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZEOLDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 07:03:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40268 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbZEOLDv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 07:03:51 -0400
Subject: Re: [PATCH] Physical Memory Management [0/1]
From: Peter Zijlstra <peterz@infradead.org>
To: =?UTF-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       m.szyprowski@samsung.com, kyungmin.park@samsung.com, linux-mm@kvack.org
In-Reply-To: <op.utyv89ek7p4s8u@amdc030>
References: <op.utu26hq77p4s8u@amdc030>
	 <20090513151142.5d166b92.akpm@linux-foundation.org>
	 <op.utwwmpsf7p4s8u@amdc030> <1242300002.6642.1091.camel@laptop>
	 <op.utw4fdhz7p4s8u@amdc030> <1242302702.6642.1140.camel@laptop>
	 <op.utw7yhv67p4s8u@amdc030>
	 <20090514100718.d8c20b64.akpm@linux-foundation.org>
	 <1242321000.6642.1456.camel@laptop> <op.utyudge07p4s8u@amdc030>
	 <20090515101811.GC16682@one.firstfloor.org>  <op.utyv89ek7p4s8u@amdc030>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 May 2009 13:03:34 +0200
Message-Id: <1242385414.26820.55.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-15 at 12:47 +0200, Michał Nazarewicz wrote:
> >> Correct me if I'm wrong, but if I understand correctly, currently only
> >> one size of huge page may be defined, even if underlaying architecture
> 
> On Fri, 15 May 2009 12:18:11 +0200, Andi Kleen wrote:
> > That's not correct, support for multiple huge page sizes was recently
> > added. The interface is a bit clumpsy admittedly, but it's there.
> 
> I'll have to look into that further then.  Having said that, I cannot
> create a huge page SysV shared memory segment with pages of specified
> size, can I?

Well, hugetlbfs is a fs, so you can simply create a file on there and
map that shared -- much saner interface than sysvshm if you ask me.

