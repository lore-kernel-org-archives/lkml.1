Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbZAENWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbZAENWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZAENWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:22:05 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:50320 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZAENWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:22:01 -0500
Subject: Re: Btrfs for mainline
From: Chris Mason <chris.mason@oracle.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-btrfs@vger.kernel.org
In-Reply-To: <200901052132.22620.nickpiggin@yahoo.com.au>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20090103.013755.42849152.ryusuke@osrg.net>
	 <1230925087.7538.41.camel@think.oraclecorp.com>
	 <200901052132.22620.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 08:21:43 -0500
Message-Id: <1231161703.4290.14.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4962096A.0193:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 21:32 +1100, Nick Piggin wrote:
> On Saturday 03 January 2009 06:38:07 Chris Mason wrote:

> > The extent_map and extent_buffer code was also intended for generic use.
> > It needs some love and care (making it work for blocksize != pagesize)
> > before I'd suggest moving it out of fs/btrfs.
> 
> I'm yet to be convinced it is a good idea to use extents for this. Been a
> long time since we visited the issue, but when you converted ext2 to use
> the extent mapping stuff, it actually went slower, and complexity went up
> a lot (IIRC possibly required allocations in the writeback path).
> 
>
> So I think it is a fine idea to live in btrfs until it is more proven and
> found useful elsewhere.

It has gotten faster since then, but it makes sense to wait on moving
extent_* code.

-chris

