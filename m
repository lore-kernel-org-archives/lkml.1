Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbXIOIqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbXIOIqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 04:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbXIOIqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 04:46:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39039 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbXIOIqH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 04:46:07 -0400
Date: Sat, 15 Sep 2007 01:44:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?SvZybg==?= Engel <joern@logfs.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-Id: <20070915014449.4f9cdb51.akpm@linux-foundation.org>
In-Reply-To: <20070911121225.GE13132@lazybastard.org>
References: <20070911060349.993975297@sgi.com>
	<200709110452.20363.nickpiggin@yahoo.com.au>
	<20070911121225.GE13132@lazybastard.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 14:12:26 +0200 Jörn Engel <joern@logfs.org> wrote:

> While I agree with your concern, those numbers are quite silly.  The
> chances of 99.8% of pages being free and the remaining 0.2% being
> perfectly spread across all 2MB large_pages are lower than those of SHA1
> creating a collision.

Actually it'd be pretty easy to craft an application which allocates seven
pages for pagecache, then one for <something>, then seven for pagecache, then
one for <something>, etc.

I've had test apps which do that sort of thing accidentally.  The result
wasn't pretty.
