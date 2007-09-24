Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbXIXMfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbXIXMfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 08:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbXIXMe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 08:34:58 -0400
Received: from smtpoutm.mac.com ([17.148.16.75]:53657 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103AbXIXMe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:34:57 -0400
In-Reply-To: <87r6kp7vfv.fsf@informatik.uni-tuebingen.de>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070916181313.GA16406@skynet.ie> <87k5qq5l36.fsf@informatik.uni-tuebingen.de> <20070917100350.GC25706@skynet.ie> <87r6kp7vfv.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <FC0BC57A-E5D3-487F-A0A6-00AA8E3578AC@mac.com>
Cc: mel@skynet.ie (Mel Gorman), Andrew Morton <akpm@linux-foundation.org>,
       Joern Engel <joern@logfs.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Mon, 24 Sep 2007 08:32:30 -0400
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 23, 2007, at 02:22:12, Goswin von Brederlow wrote:
> mel@skynet.ie (Mel Gorman) writes:
>> On (16/09/07 23:58), Goswin von Brederlow didst pronounce:
>>> But when you already have say 10% of the ram in mixed groups then  
>>> it is a sign the external fragmentation happens and some time  
>>> should be spend on moving movable objects.
>>
>> I'll play around with it on the side and see what sort of results  
>> I get.  I won't be pushing anything any time soon in relation to  
>> this though.  For now, I don't intend to fiddle more with grouping  
>> pages by mobility for something that may or may not be of benefit  
>> to a feature that hasn't been widely tested with what exists today.
>
> I watched the videos you posted. A nice and quite clear improvement  
> with and without your logic. Cudos.
>
> When you play around with it may I suggest a change to the display  
> of the memory information. I think it would be valuable to use a  
> Hilbert Curve to arange the pages into pixels. Like this:
>
> # #  0  3
> # #
> ###  1  2
>
> ### ###  0 1 E F
>   # #
> ### ###  3 2 D C
> #     #
> # ### #  4 7 8 B
> # # # #
> ### ###  5 6 9 A

Here's an excellent example of an 0-255 numbered hilbert curve used  
to enumerate the various top-level allocations of IPv4 space:
http://xkcd.com/195/

Cheers,
Kyle Moffett

