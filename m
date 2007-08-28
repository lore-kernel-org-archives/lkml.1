Return-Path: <linux-kernel-owner+w=401wt.eu-S1762438AbXH1Tzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762438AbXH1Tzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932546AbXH1Tzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:55:41 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35593 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932530AbXH1Tzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:55:39 -0400
Date: Tue, 28 Aug 2007 12:55:38 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Christoph Hellwig <hch@lst.de>
cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [00/36] Large Blocksize Support V6
In-Reply-To: <20070828192034.GA13883@lst.de>
Message-ID: <Pine.LNX.4.64.0708281254070.16473@schroedinger.engr.sgi.com>
References: <20070828190551.415127746@sgi.com> <20070828192034.GA13883@lst.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007, Christoph Hellwig wrote:

> one patch per file is the most braindead and most unacceptable way
> to split a series.  Please stop whatever you're doing right now and
> correct it and send out a patch that has one patch per logical change
> for the whole tree.  This means people can actually read the patch,
> and it's bisectable.

The patches are per logical change aside from the first patches that 
introduce the page cache functions all over the kernel. It would be 
unacceptably big and difficult to merge if I put them all together.

