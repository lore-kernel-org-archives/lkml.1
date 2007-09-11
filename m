Return-Path: <linux-kernel-owner+w=401wt.eu-S967402AbXIKUl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967402AbXIKUl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933846AbXIKUlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:41:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58450 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933845AbXIKUlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:41:11 -0400
Date: Tue, 11 Sep 2007 13:41:08 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <20070911202942.GB20688@lazybastard.org>
Message-ID: <Pine.LNX.4.64.0709111337510.26598@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au>
 <20070911121225.GE13132@lazybastard.org> <Pine.LNX.4.64.0709111303590.25781@schroedinger.engr.sgi.com>
 <20070911202942.GB20688@lazybastard.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-1212738686-1189543268=:26598"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-1212738686-1189543268=:26598
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 11 Sep 2007, J=F6rn Engel wrote:

> What I'm starting to wonder about is where your approach has advantages
> over Andrea's.  The chances of triggering something vaguely similar to
> Nick's worst case scenario are certainly higher for your solution.  So
> unless there are other upsides it is just the second-best solution.

Nick's worst case scenario is already at least partially addressed by the=
=20
Lumpy Reclaim code in 2.6.23. His examples assume 2.6.22 or earlier=20
code.

The advantages of this approach over Andreas is basically that the 4k=20
filesystems still can be used as is. 4k is useful for binaries and for=20
text processing like used for compiles. Large Page sizes are useful for=20
file systems that contain large datasets (scientific data, multimedia=20
stuff, databases) for applications that depend on high I/O throughput.

---1700579579-1212738686-1189543268=:26598--
