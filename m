Return-Path: <linux-kernel-owner+w=401wt.eu-S965698AbXDWKMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965698AbXDWKMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 06:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965712AbXDWKMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 06:12:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965698AbXDWKMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 06:12:21 -0400
Message-ID: <462C8675.9000302@redhat.com>
Date: Mon, 23 Apr 2007 06:12:05 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, shak <dshaks@redhat.com>,
       jakub@redhat.com, drepper@redhat.com
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
References: <46247427.6000902@redhat.com>	<20070420135715.f6e8e091.akpm@linux-foundation.org>	<462932BE.4020005@redhat.com> <20070420150618.179d31a4.akpm@linux-foundation.org> <4629524C.5040302@redhat.com> <462ACA40.8070407@yahoo.com.au> <462B0156.9020407@redhat.com> <462BFAF3.4040509@yahoo.com.au> <462C2DC7.5070709@redhat.com> <462C2EDE.4090805@yahoo.com.au> <462C8560.7060703@yahoo.com.au>
In-Reply-To: <462C8560.7060703@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:

> I haven't tested your MADV_FREE patch yet.

Good.  It turned out that one behaved a bit strange without tlb batching 
anyway.

I'm now running ebizzy across the whole set of kernels I tested before,
and will post the results in a bit.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
