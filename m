Return-Path: <linux-kernel-owner+w=401wt.eu-S969402AbXILO3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969402AbXILO3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 10:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966796AbXILO3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 10:29:44 -0400
Received: from dvhart.com ([64.146.134.43]:52909 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966365AbXILO3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 10:29:43 -0400
Message-ID: <46E7F7D3.2020804@mbligh.org>
Date: Wed, 12 Sep 2007 07:29:39 -0700
From: "Martin J. Bligh" <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Mel Gorman <mel@skynet.ie>,
       andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
References: <20070911060349.993975297@sgi.com> <200709111144.48743.nickpiggin@yahoo.com.au> <20070911205350.GA18127@skynet.ie> <200709111600.18756.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709111446080.27023@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709111446080.27023@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 11 Sep 2007, Nick Piggin wrote:
> 
>> But that's not my place to say, and I'm actually not arguing that high
>> order pagecache does not have uses (especially as a practical,
>> shorter-term solution which is unintrusive to filesystems).
>>
>> So no, I don't think I'm really going against the basics of what we agreed
>> in Cambridge. But it sounds like it's still being billed as first-order
>> support right off the bat here.
> 
> Well its seems that we have different interpretations of what was agreed 
> on. My understanding was that the large blocksize patchset was okay 
> provided that I supply an acceptable mmap implementation and put a 
> warning in.

I think all we agreed on was that both patches needed significant work
and would need to be judged after they were completed ;-)

There was talk of putting Christoph's approach in more-or-less as-is
as a very specialized and limited application ... but I don't think
we concluded anything for the more general and long-term case apart
from "this is hard" ;-)

M.
