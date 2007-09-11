Return-Path: <linux-kernel-owner+w=401wt.eu-S932674AbXIKVsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674AbXIKVsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759319AbXIKVry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:47:54 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:41811 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759026AbXIKVrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:47:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3jDVCPD8N3RKGM+ekbispRXgJEpqsMfVtpsgtvTXqapgtskgWkjpupFHg8+bIN8sOqdpVDNjDoY8cGbVijmzff5L0p7eD20yIySrzjKI19JcVfjQtTpa0vLPEnZggjyMXM2yqY2tx70CteF39n/C+nxpjskjKEqfv2AyTYHPzG0=  ;
X-YMail-OSG: ectI8wkVM1ltHRR7F4E.acobgT12H2UwiTHz7W8rESzH9pYz14f5XOnT00eunKHPhS3hkBIDEA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Tue, 11 Sep 2007 16:06:09 +1000
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
References: <20070911060349.993975297@sgi.com> <200709111530.16136.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709111439280.27023@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709111439280.27023@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709111606.10873.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007 07:41, Christoph Lameter wrote:
> On Tue, 11 Sep 2007, Nick Piggin wrote:
> > I think I would have as good a shot as any to write a fragmentation
> > exploit, yes. I think I've given you enough info to do the same, so I'd
> > like to hear a reason why it is not a problem.
>
> No you have not explained why the theoretical issues continue to exist
> given even just considering Lumpy Reclaim in .23 nor what effect the
> antifrag patchset would have.

So how does lumpy reclaim, your slab patches, or anti-frag have
much effect on the worst case situation? Or help much against a
targetted fragmentation attack?


> And you have used a 2M pagesize which is 
> irrelevant to this patchset that deals with blocksizes up to 64k. In my
> experience the use of blocksize < PAGE_COSTLY_ORDER (32k) is reasonably
> safe.

I used EXACTLY the page sizes that you brought up in your patch
description (ie. 64K and 2MB).
