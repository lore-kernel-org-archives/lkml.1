Return-Path: <linux-kernel-owner+w=401wt.eu-S1759860AbXIMJFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860AbXIMJFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbXIMJFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:05:08 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:30636 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752771AbXIMJFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:05:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4dq1IKSwG/+TBHbe0X68hzIH8sjJyLSFDYcmnR0RJ9ynwByNCk80TnSwo7jzI6N43ASYgKlOcJHeXJ3/H8QlPULGct3SyRe65ri6XRLfuKFN112HoX+HJ2UC4LIpcE717bY0MV1GhfsmAscLdSvqfR7CVK0zm7e+BDQRSjn5DhE=  ;
X-YMail-OSG: smVmK_UVM1kuCC7DmILhAIXNCT0fZSv_xQQ9VbAiw0ONfEYX6Ke8yQEAfXriJtE_0x64JLmiLA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Chinner <dgc@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Thu, 13 Sep 2007 03:23:21 +1000
User-Agent: KMail/1.9.5
Cc: Mel Gorman <mel@skynet.ie>, Christoph Lameter <clameter@sgi.com>,
       andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com> <200709120127.33832.nickpiggin@yahoo.com.au> <20070913014905.GV995458@sgi.com>
In-Reply-To: <20070913014905.GV995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709130323.22534.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2007 11:49, David Chinner wrote:
> On Wed, Sep 12, 2007 at 01:27:33AM +1000, Nick Piggin wrote:

> > I just gave 4 things which combined might easily reduce xfs vmap overhead
> > by several orders of magnitude, all without changing much code at all.
>
> Patches would be greatly appreciately. You obviously understand this
> vm code much better than I do, so if it's easy to fix by adding some
> generic vmap cache thingy, please do.

Well, it may not be easy to _fix_, but it's easy to try a few improvements ;)

How do I make an image and run a workload that will coerce XFS into
doing a significant number of vmaps?
