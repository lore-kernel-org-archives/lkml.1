Return-Path: <linux-kernel-owner+w=401wt.eu-S933084AbXCMLkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084AbXCMLkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 07:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933099AbXCMLkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 07:40:43 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:34085 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933084AbXCMLkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 07:40:43 -0400
From: Eric Dumazet <dada1@cosmosbay.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: SMP performance degradation with sysbench
Date: Tue, 13 Mar 2007 12:40:47 +0100
User-Agent: KMail/1.9.5
Cc: Andrea Arcangeli <andrea@suse.de>, Anton Blanchard <anton@samba.org>,
       Rik van Riel <riel@redhat.com>,
       Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
References: <1172425476.5489.11.camel@odyssey.lan> <20070313105742.GG8992@v2.random> <45F68713.9040608@yahoo.com.au>
In-Reply-To: <45F68713.9040608@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703131240.47785.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2007 12:12, Nick Piggin wrote:
>
> I guess googlemalloc (tcmalloc?) isn't suitable for a general purpose
> glibc allocator. But I wonder if there are other improvements that glibc
> can do here?

I cooked a patch some time ago to speedup threaded apps and got no feedback.

http://lkml.org/lkml/2006/8/9/26

Maybe we have to wait for 32 core cpu before thinking of cache line 
bouncings...

