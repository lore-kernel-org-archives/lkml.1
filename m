Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYHULIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYHULIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184AbYHULHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:07:55 -0400
Received: from mail2.shareable.org ([80.68.89.115]:57131 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbYHULHy (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:07:54 -0400
Date: Thu, 21 Aug 2008 12:07:50 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Jared Hulbert <jaredeh@gmail.com>
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, tim.bird@AM.SONY.COM,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Message-ID: <20080821110749.GA1926@shareable.org>
References: <48AD00C4.6060302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AD00C4.6060302@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:
> The biggest improvement is in the way AXFS allows for each page to be XIP or
> not.  First, a user collects information about which pages are accessed on a
> compressed image for each mmap()ed region from /proc/axfs/volume0.  That
> 'profile' is used as an input to the image builder.  The resulting image has
> only the relevant pages uncompressed and XIP.  The result is smaller memory
> sizes and faster launches.

Sounds great, really nice idea.

How does it fare with no MMU?  Can the profiler and image builder lay
out the XIP pages in such a way that no-MMU mmaps can map those regions?

No complaint if not, it would be a nice bonus though.

-- Jamie
