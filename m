Return-Path: <linux-kernel-owner+w=401wt.eu-S1422843AbXDXRsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422843AbXDXRsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422883AbXDXRsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:48:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50993 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422843AbXDXRsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:48:41 -0400
Date: Tue, 24 Apr 2007 10:48:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
In-Reply-To: <Pine.LNX.4.64.0704241841190.19956@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0704241047570.8418@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
 <20070423142919.5809e03f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
 <20070423154224.15ebf8f7.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704241036020.8341@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0704241841190.19956@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Hugh Dickins wrote:

> > And if a page is in the wrong area then it can be bounced before I/O 
> > is performed on it.
> 
> I think that much is also true, but not where the problem lies.
> Isn't the problem that filesystems using these block devices
> expect their metadata to be accessible without kmap calls?

Metadata is not movable nor subject to memory policies. It will never be 
mapped into a process space.


