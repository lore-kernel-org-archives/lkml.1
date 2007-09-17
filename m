Return-Path: <linux-kernel-owner+w=401wt.eu-S1759850AbXIQWDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850AbXIQWDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 18:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758948AbXIQWDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 18:03:11 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35290 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758860AbXIQWDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 18:03:09 -0400
Date: Mon, 17 Sep 2007 15:03:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <20070916175352.GB2393@lazybastard.org>
Message-ID: <Pine.LNX.4.64.0709171501520.29993@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au>
 <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org>
 <20070916175352.GB2393@lazybastard.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-134139651-1190066587=:29993"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-134139651-1190066587=:29993
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 16 Sep 2007, J=F6rn Engel wrote:

> I bet!  My (false) assumption was the same as Goswin's.  If non-movable
> pages are clearly seperated from movable ones and will evict movable
> ones before polluting further mixed superpages, Nick's scenario would be
> nearly infinitely impossible.
>=20
> Assumption doesn't reflect current code.  Enforcing this assumption
> would cost extra overhead.  The amount of effort to make Christoph's
> approach work reliably seems substantial and I have no idea whether it
> would be worth it.

My approach is based on Mel's code and is already working the way you=20
describe. Page cache allocs are marked __GFP_MOVABLE by Mel's work.


---1700579579-134139651-1190066587=:29993--
