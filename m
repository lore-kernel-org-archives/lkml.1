Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbXFZDXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbXFZDXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 23:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbXFZDXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 23:23:23 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:50592 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbXFZDXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 23:23:22 -0400
Date: Mon, 25 Jun 2007 21:23:20 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, "Martin J. Bligh" <mbligh@mbligh.org>
Subject: Re: vm/fs meetup in september?
Message-ID: <20070626032320.GN5181@schatzie.adilger.int>
Mail-Followup-To: Nick Piggin <nickpiggin@yahoo.com.au>,
	Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-fsdevel@vger.kernel.org, "Martin J. Bligh" <mbligh@mbligh.org>
References: <20070624042345.GB20033@wotan.suse.de> <20070625063545.GA1964@infradead.org> <46807B5D.6090604@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46807B5D.6090604@yahoo.com.au>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 26, 2007  12:35 +1000, Nick Piggin wrote:
> Leaving my opinion of higher order pagecache aside, this _may_ be an
> example of something that doesn't need a lot of attention, because it
> should be fairly uncontroversial from a filesystem's POV? (eg. it is
> more a relevant item to memory management and possibly block layer).
> OTOH if it is discussed in the context of "large blocks in the buffer
> layer is crap because we can do it with higher order pagecache", then
> that might be interesting :)

FWIW, being able to have large (8-64kB) blocksize would be great for
ext2/3/4.  We'd sort of been betting on this by limiting the on-disk
extent format to 48-bit physical block numbers, and to have 2 patches
to implement this in as many weeks is excellent.

To me the mechanism doesn't matter, whether through fsblock or high-order
PAGE_SIZE.  I'll let the rest of you duke it out as long as at least one
of them makes it into the kernel.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

