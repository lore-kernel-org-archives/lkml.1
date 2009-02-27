Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbZB0PvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbZB0PvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 10:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757609AbZB0PvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 10:51:08 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:42486 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755659AbZB0PvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 10:51:07 -0500
Date: Fri, 27 Feb 2009 10:40:17 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nick Piggin <npiggin@suse.de>
cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, penberg@cs.helsinki.fi, riel@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org,
       linux-kernel@vger.kernel.org, ming.m.lin@intel.com,
       yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 20/20] Get rid of the concept of hot/cold page freeing
In-Reply-To: <20090227113333.GA21296@wotan.suse.de>
Message-ID: <alpine.DEB.1.10.0902271039440.31801@qirst.com>
References: <20090223233030.GA26562@csn.ul.ie> <20090223155313.abd41881.akpm@linux-foundation.org> <20090224115126.GB25151@csn.ul.ie> <20090224160103.df238662.akpm@linux-foundation.org> <20090225160124.GA31915@csn.ul.ie> <20090225081954.8776ba9b.akpm@linux-foundation.org>
 <20090226163751.GG32756@csn.ul.ie> <alpine.DEB.1.10.0902261157100.7472@qirst.com> <20090226171549.GH32756@csn.ul.ie> <alpine.DEB.1.10.0902261226370.26440@qirst.com> <20090227113333.GA21296@wotan.suse.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009, Nick Piggin wrote:

> > I hope we can get rid of various ugly elements of the quicklists if the
> > page allocator would offer some sort of support. I would think that the
>
> Only if it provides significant advantages over existing quicklists or
> adds *no* extra overhead to the page allocator common cases. :)

And only if the page allocator gets fast enough to be usable for
allocs instead of quicklists.

