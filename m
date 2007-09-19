Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbXISE56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbXISE56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 00:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbXISE5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 00:57:49 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:50703 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbXISE5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 00:57:48 -0400
Message-ID: <46F0AC06.1030208@gmail.com>
Date: Wed, 19 Sep 2007 06:56:38 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrea Arcangeli <andrea@suse.de>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
References: <20070911060349.993975297@sgi.com> <200709161853.12050.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com> <200709181116.22573.nickpiggin@yahoo.com.au> <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org> <20070918191853.GB7541@v2.random> <alpine.LFD.0.999.0709181239320.16478@woody.linux-foundation.org> <46F09A80.8020605@gmail.com> <alpine.LFD.0.999.0709182049480.16478@woody.linux-foundation.org> <46F0A4FB.2020901@gmail.com> <alpine.LFD.0.999.0709182131560.16478@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709182131560.16478@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2007 06:33 AM, Linus Torvalds wrote:

> On Wed, 19 Sep 2007, Rene Herman wrote:

>> I do feel larger blocksizes continue to make sense in general though. Packet
>> writing on CD/DVD is a problem already today since the hardware needs 32K or
>> 64K blocks and I'd expect to see more of these and similiar situations when
>> flash gets (even) more popular which it sort of inevitably is going to be.
> 
> .. that's what scatter-gather exists for.
> 
> What's so hard with just realizing that physical memory isn't contiguous?
> 
> It's why we have MMU's. It's why we have scatter-gather. 

So if I understood that right, you'd suggest to deal with devices with 
larger physical blocksizes at some level above the current blocklayer.

Not familiar enough with either block or fs to be able to argue that 
effectively...

Rene.

