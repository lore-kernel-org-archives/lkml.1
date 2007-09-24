Return-Path: <linux-kernel-owner+w=401wt.eu-S1761869AbXIXRxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761869AbXIXRxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbXIXRwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:52:55 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:64601 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756139AbXIXRwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:52:55 -0400
Date: Mon, 24 Sep 2007 13:52:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/7] Seq_file add support for sorted list
Message-ID: <20070924175252.GA28347@Krystal>
References: <20070924164950.006047409@polymtl.ca> <20070924165426.841607414@polymtl.ca> <20070924173759.GA1608@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070924173759.GA1608@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:47:48 up 56 days, 18:06,  6 users,  load average: 1.53, 1.20, 1.45
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Mon, Sep 24, 2007 at 12:49:51PM -0400, Mathieu Desnoyers wrote:
> > Add support for sorted list in seq_file. It aims at changing the way
> > /proc/modules and kallsyms iterates on the module list to remove a race between
> > module unload and module/symbol listing.
> > 
> > The list is sorted by ascending list_head pointer address.
> 
> While I think we really want this patch I don't quite see how it's
> related to the markers.  I think patch 1 and 2 stand on their own.
> 

As they are currently implemented, the markers use the sorted module
list for marker listing, but I can change their implementation so they
do not require this (and make it a subsequent patch instead).

I could do that to diminish the patchset size a little more. However, it
implies using an interface with a known race condition. Could we just
post this as two different patchsets instead ? I really think the sorted
module list would be important to get in and I don't like to use buggy
unfixed lower level functions.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
