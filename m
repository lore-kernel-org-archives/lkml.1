Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbXIQLsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbXIQLsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 07:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbXIQLsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 07:48:19 -0400
Received: from mailout10.sul.t-online.de ([194.25.134.21]:52235 "EHLO
	mailout10.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755124AbXIQLsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 07:48:18 -0400
Message-ID: <46EE60C1.7030507@t-online.de>
Date: Mon, 17 Sep 2007 13:10:57 +0200
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070810)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Mel Gorman <mel@csn.ul.ie>,
       andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
References: <20070911060349.993975297@sgi.com> <200709111606.10873.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709111448430.27023@schroedinger.engr.sgi.com> <200709120407.48344.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709121551340.4204@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709121551340.4204@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: ZB2+h0ZQ8heIYngtl4BQsRrKG5MsxTm-zCQz1qabFDaccGRiwfh33u8SzLFktaTZxM
X-TOI-MSGID: e4ab883a-b1b6-4c1b-bc80-f5d8709cfcb4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> True. That is why we want to limit the number of unmovable allocations and 
> that is why ZONE_MOVABLE exists to limit those. However, unmovable 
> allocations are already rare today. The overwhelming majority of 
> allocations are movable and reclaimable. You can see that f.e. by looking 
> at /proc/meminfo and see how high SUnreclaim: is (does not catch 
> everything but its a good indicator).

Just to inject another factor into the discussion, please remember that 
Linux also runs on nommu systems, where things like user space 
allocations are neither movable nor reclaimable.


Bernd

-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
