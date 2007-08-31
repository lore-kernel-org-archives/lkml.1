Return-Path: <linux-kernel-owner+w=401wt.eu-S932981AbXHaHDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981AbXHaHDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 03:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759654AbXHaHDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 03:03:44 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60237 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759058AbXHaHDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 03:03:43 -0400
Date: Fri, 31 Aug 2007 00:03:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: Dmitry Monakhov <dmonakhov@sw.ru>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [11/36] Use page_cache_xxx in fs/buffer.c
In-Reply-To: <20070831065613.GH29452@kernel.dk>
Message-ID: <Pine.LNX.4.64.0708310003280.14375@schroedinger.engr.sgi.com>
References: <20070828190551.415127746@sgi.com> <20070828190730.220393749@sgi.com>
 <20070830092038.GD22586@dnb.sw.ru> <Pine.LNX.4.64.0708301113170.7975@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0708301843280.13292@schroedinger.engr.sgi.com>
 <20070831065613.GH29452@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007, Jens Axboe wrote:

> > So if we try to push a too large buffer down with submit_bh() we get a 
> > failure.
> 
> Only partly, you may be violating a number of other restrictions (size
> is many things, not just length of the data).

Could you be more specific?

