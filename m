Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbZENTd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbZENTd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 15:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZENTdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 15:33:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:32935 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbZENTdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 15:33:16 -0400
To: =?iso-8859-1?Q?Micha=E2?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       m.szyprowski@samsung.com, kyungmin.park@samsung.com, linux-mm@kvack.org
Subject: Re: [PATCH] Physical Memory Management [0/1]
From: Andi Kleen <andi@firstfloor.org>
References: <op.utu26hq77p4s8u@amdc030>
	<20090513151142.5d166b92.akpm@linux-foundation.org>
	<op.utwwmpsf7p4s8u@amdc030> <1242300002.6642.1091.camel@laptop>
	<op.utw4fdhz7p4s8u@amdc030>
Date: Thu, 14 May 2009 21:33:11 +0200
In-Reply-To: <op.utw4fdhz7p4s8u@amdc030> (=?iso-8859-1?Q?Micha=E2?=
 Nazarewicz's message of "Thu, 14 May 2009 13:48:39 +0200")
Message-ID: <87skj7pjig.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michaâ Nazarewicz <m.nazarewicz@samsung.com> writes:
>
> The idea here is that there are n hardware accelerators, each
> can operate on 1MiB blocks (to simplify assume that's the case).

You could just define a hugepage size for that and use hugetlbfs
with a few changes to map in pages with multiple PTEs.
It supports boot time reservation and is a well established
interface.

On x86 that would give 2MB units, on other architectures whatever
you prefer.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
