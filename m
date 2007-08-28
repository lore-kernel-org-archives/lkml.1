Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbXH1Xov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbXH1Xov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 19:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbXH1Xon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 19:44:43 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:27711 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752401AbXH1Xom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 19:44:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=yT/oA6Dgj2hAQjP1ifMzRUznQTw+Fy3S9xCRUxFKX5VELcbjDy68oKrtWKAlJCGgPAPcHE5O5oAqgG9AIaddB+gnkfH6s/0OLaFXpUXMxeMxnla4elqgrTtCL4HcCtSPEj/n3agGUgYcoO9nAvEcaR3CF0fyJdOR01v+fiSoxfM=  ;
X-YMail-OSG: GFnmXs8VM1kQofsortyn2wAPWHGGWLabytDKGt7_XcpbckwXYRUsvigACfBmAdXNwqmitCkIdQ--
Message-ID: <46D4B356.7060604@yahoo.com.au>
Date: Wed, 29 Aug 2007 09:44:22 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: mingo@elte.hu, mingo@redhat.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -rt 1/8] introduce PICK_FUNCTION
References: <20070828213748.790253419@mvista.com>
In-Reply-To: <20070828213748.790253419@mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> PICK_FUNCTION() is similar to the other PICK_OP style macros, and was
> created to replace them all. I used variable argument macros to handle
> PICK_FUNC_2ARG/PICK_FUNC_1ARG. Otherwise the marcos are similar to the
> original macros used for semaphores. The entire system is used to do a
> compile time switch between two different locking APIs. For example,
> real spinlocks (raw_spinlock_t) and mutexes (or sleeping spinlocks).
> 
> This new macro replaces all the duplication from lock type to lock type.
> The result of this patch, and the next two, is a fairly nice simplification,
> and consolidation. Although the seqlock changes are larger than the originals
> I think over all the patchset is worth while.
> 
> Incorporated peterz's suggestion to not require TYPE_EQUAL() to only
> use pointers.

How come this is cc'ed to lkml? Is it something that is relevant to
the mainline kernel... or?

-- 
SUSE Labs, Novell Inc.
