Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbXIRLHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbXIRLHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 07:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbXIRLGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 07:06:55 -0400
Received: from lazybastard.de ([212.112.238.170]:52795 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbXIRLGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 07:06:54 -0400
Date: Tue, 18 Sep 2007 12:49:49 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Mel Gorman <mel@skynet.ie>
Cc: Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joern Engel <joern@logfs.org>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070918104948.GA9082@lazybastard.org>
References: <20070911060349.993975297@sgi.com> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070916181313.GA16406@skynet.ie> <200709161903.37295.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709171458541.29993@schroedinger.engr.sgi.com> <20070918100040.GB2035@skynet.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070918100040.GB2035@skynet.ie>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 September 2007 11:00:40 +0100, Mel Gorman wrote:
> 
> We still lack data on what sort of workloads really benefit from large
> blocks

Compressing filesystems like jffs2 and logfs gain better compression
ratio with larger blocks.  Going from 4KiB to 64KiB gave somewhere
around 10% benefit iirc.  Testdata was a 128MiB qemu root filesystem.

Granted, the same could be achieved by adding some extra code and a few
bounce buffers to the filesystem.  How suck a hack would perform I'd
prefer not to find out, though. :)

Jörn

-- 
Write programs that do one thing and do it well. Write programs to work
together. Write programs to handle text streams, because that is a
universal interface.
-- Doug MacIlroy
