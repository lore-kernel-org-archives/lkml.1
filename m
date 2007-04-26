Return-Path: <linux-kernel-owner+w=401wt.eu-S933112AbXDZHOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbXDZHOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933127AbXDZHOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:14:17 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:27409 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933112AbXDZHOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:14:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=3XHUsuBmlHfBl+wR1p6NEI8pDTo8KpOv99xVg/FhXmZdav0EmYt7DjKX6VEiTDzkLwUEg3+OCbAA9T/l6D5PxbFvKjClLj/v8nLRs1CczGqNscgIJczE5LgBgdBJZVPkTE0p0fsf1FAaw5MTxikHSiZ2FZI36UnM5PvM9SDEfzI=  ;
X-YMail-OSG: cLNkmtEVM1l9QYlYxkXRnzueoQ.ByhJkviZ2o0NeA7t4PCoZTIoCPGQznhruwIr_EfwzaRxJWg--
Message-ID: <46304FAF.7020700@yahoo.com.au>
Date: Thu, 26 Apr 2007 17:07:27 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au> <20070426070454.GF32602149@melbourne.sgi.com>
In-Reply-To: <20070426070454.GF32602149@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> On Thu, Apr 26, 2007 at 04:53:40PM +1000, Nick Piggin wrote:
> 
>>Christoph Lameter wrote:
>>
>>>On Thu, 26 Apr 2007, Nick Piggin wrote:
>>>
>>>>I am working now and again on some code to do this, it is a big job but
>>>>I think it is the right way to do it. But it would take a long time to
>>>>get stable and supported by filesystems...
>>>
>>>Ummm... We already have a radix tree for this???? What more is needed? You 
>>>just need to go through all filesystems and make them use extends.
>>
>>I'm talking about block size > page size in the buffer layer.
> 
> 
> Nick, what's the buffer layer? Are you talking about operations
> based on bufferheads?

Yeah. Our pgoff_t->sector_t translation.

-- 
SUSE Labs, Novell Inc.
