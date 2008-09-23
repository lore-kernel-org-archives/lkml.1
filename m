Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbYIWNTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbYIWNTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYIWNT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:19:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357AbYIWNTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:19:25 -0400
Message-ID: <48D8ECB3.8070109@linux-foundation.org>
Date: Tue, 23 Sep 2008 08:18:43 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Jerome Glisse <glisse@freedesktop.org>
CC: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>,
       Nick Piggin <npiggin@suse.de>, keith.packard@intel.com, eric@anholt.net,
       hugh@veritas.com, hch@infradead.org, airlied@linux.ie,
       jbarnes@virtuousgeek.org, dri-devel@lists.sourceforge.net,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] mm: pageable memory allocator (for DRM-GEM?)
References: <20080923091017.GB29718@wotan.suse.de>	<48D8C326.80909@tungstengraphics.com> <20080923133137.c9e1f171.glisse@freedesktop.org>
In-Reply-To: <20080923133137.c9e1f171.glisse@freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jerome Glisse wrote:
> 
> Also what about a uncached page allocator ? As some drivers might need
> them, there is no number but i think their was some concern that changing
> PAT too often might be costly and that we would better have a poll of
> such pages.

IA64 has an uncached allocator. See arch/ia64/include/asm/incached.h and
arch/ia64/kernel/uncached.c. Probably not exactly what you want but its a
starting point.


