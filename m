Return-Path: <linux-kernel-owner+w=401wt.eu-S1423028AbXDXUMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423028AbXDXUMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423032AbXDXUMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:12:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59792 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423028AbXDXUMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:12:43 -0400
Date: Tue, 24 Apr 2007 13:12:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
In-Reply-To: <20070424131042.38c8cbff.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704241311390.13005@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
 <20070423142919.5809e03f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
 <20070423154224.15ebf8f7.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704241042550.8418@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0704241941421.28487@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704241234341.12753@schroedinger.engr.sgi.com>
 <20070424124922.d406aac1.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241256470.12907@schroedinger.engr.sgi.com>
 <20070424131042.38c8cbff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Andrew Morton wrote:

> > A highmem page can have buffers???
> 
> yep.  Take a 4k page which is stored in four discontiguous 1k disk blocks. The
> data at page_buffers(page) is the sole way in which we track which parts of
> the page belong to which blocks of the disk.

But I see no use of kmap for buffer access? The data is not accessible.


