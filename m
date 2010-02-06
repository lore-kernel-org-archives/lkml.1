Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0BFQI6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 11:08:58 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:46800 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab0BFQI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 11:08:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nhefuPlTOcC1kw+xC63AMISp50KV+8JyGkwVC7lbpG3lkj/QohvkN4nSoWLoUtfGtT
         u/kZ7LpOjD/ptWEE6sUxOgkgWN38scl0X7PoMDnwUhbcY4gg0I+T/C1/cK1AYISIKetE
         I0RHn4aejI1eMYfdRfH2OMJ1+H7r5McIFzin8=
Date: Sat, 6 Feb 2010 17:08:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to
	get to performance counters
Message-ID: <20100206160849.GA5060@nowhere>
References: <20090925122556.2f8bd939@infradead.org> <20100205154748.GA11469@infradead.org> <20100205222430.1d17a72c@infradead.org> <20100206114634.GE5062@nowhere> <1265465922.30057.510.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265465922.30057.510.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 06, 2010 at 03:18:42PM +0100, Peter Zijlstra wrote:
> On Sat, 2010-02-06 at 12:46 +0100, Frederic Weisbecker wrote:
> 
> > We can't. It has a user merged upstream: the hw-breakpoint subsystem.
> 
> That's non modular, so removing that EXPORT still makes sense.


Yeah, the export can be zapped, indeed.

