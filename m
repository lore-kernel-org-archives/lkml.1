Return-Path: <linux-kernel-owner+w=401wt.eu-S1764943AbXIKVMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764943AbXIKVMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763804AbXIKVLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:11:53 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:23803 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758996AbXIKVLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:11:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cDTlWx4+D8AyRFk0q6JOAKq34eIaMczt7Z7I9lH37woarLhktOu2P/Vu0AjiEBKVsmzlYlftjq4iuAWxAtOTZ4iBZcPIG+/xzx8YbISd4MWv8oehi4LbW4GH5WWG4iGutLJUBoaP9NU1D22SKSfeC0TA1U+n89IOwHxsps4hMkQ=  ;
X-YMail-OSG: gLSrmLIVM1m6ss1TWe80KZUWbgACDcuYVA1JP1HeomDCNy0dAtOfBWYMeDHJfDv7YlbRLmDGWQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Tue, 11 Sep 2007 15:30:15 +1000
User-Agent: KMail/1.9.5
Cc: Mel Gorman <mel@csn.ul.ie>, andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com> <200709111453.42650.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709111341130.26598@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709111341130.26598@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709111530.16136.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007 06:42, Christoph Lameter wrote:
> On Tue, 11 Sep 2007, Nick Piggin wrote:
> > > I guess you would have to run that without my targeted slab reclaim
> > > patchset? Otherwise the slab that are in the way could be reclaimed and
> > > you could not produce your test case.
> >
> > I didn't realise you had patches to move pinned dentries, radix tree
> > nodes, task structs, page tables etc. Did I miss them in your last
> > patchset?
>
> You did not mention that in your earlier text.

Actually, I am pretty sure actually everything I mentioned was explicitly
things that your patches do not handle. This was not a coincidence.


> If these are issues then we 
> certainly can work on that. Could you first provide us some real failure
> conditions so that we know that these are real problems?

I think I would have as good a shot as any to write a fragmentation
exploit, yes. I think I've given you enough info to do the same, so I'd
like to hear a reason why it is not a problem.
