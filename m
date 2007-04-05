Return-Path: <linux-kernel-owner+w=401wt.eu-S1946092AbXDEIaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946092AbXDEIaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 04:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946090AbXDEIaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 04:30:14 -0400
Received: from holomorphy.com ([66.93.40.71]:39022 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946096AbXDEIaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 04:30:13 -0400
Date: Thu, 5 Apr 2007 01:30:21 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [i386] Use page allocator to allocate threadinfo structure
Message-ID: <20070405083021.GR2986@holomorphy.com>
References: <Pine.LNX.4.64.0704041734270.22851@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704041734270.22851@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 05:40:31PM -0700, Christoph Lameter wrote:
> Replace the calls to kmalloc with calls into the page allocator.
> An alternate solution may be to create a custom slab cache where the 
> alignment is set to PAGE_SIZE. That would allow slub debugging to be 
> applied to the threadinfo structure.
> Signed-off-by: Christoph Lameter <clameter@sgi.com>

This was originally made a slab allocation as a preparatory cleanup
for things that were never merged, and are never likely to be. One
might as well revert it, though it does make stack space usage
slightly more difficult to account for.


-- wli
