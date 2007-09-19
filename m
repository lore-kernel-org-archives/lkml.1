Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbXISE1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbXISE1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 00:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbXISE1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 00:27:45 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:59423 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbXISE1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 00:27:44 -0400
Message-ID: <46F0A4FB.2020901@gmail.com>
Date: Wed, 19 Sep 2007 06:26:35 +0200
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
References: <20070911060349.993975297@sgi.com> <200709161853.12050.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com> <200709181116.22573.nickpiggin@yahoo.com.au> <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org> <20070918191853.GB7541@v2.random> <alpine.LFD.0.999.0709181239320.16478@woody.linux-foundation.org> <46F09A80.8020605@gmail.com> <alpine.LFD.0.999.0709182049480.16478@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709182049480.16478@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2007 05:50 AM, Linus Torvalds wrote:

> On Wed, 19 Sep 2007, Rene Herman wrote:

>> Well, not so sure about that. What if one of your expected uses for example is
>> video data storage -- lots of data, especially for multiple streams, and needs
>> still relatively fast machinery. Why would you care for the overhead af
>> _small_ blocks?
> 
> .. so work with an extent-based filesystem instead.
> 
> 16k blocks are total idiocy. If this wasn't about a "support legacy 
> customers", I think the whole patch-series has been a total waste of time.

Admittedly, extent-based might not be a particularly bad answer at least to 
the I/O side of the equation...

I do feel larger blocksizes continue to make sense in general though. Packet 
writing on CD/DVD is a problem already today since the hardware needs 32K or 
64K blocks and I'd expect to see more of these and similiar situations when 
flash gets (even) more popular which it sort of inevitably is going to be.

Rene.
