Return-Path: <linux-kernel-owner+w=401wt.eu-S1946010AbXBIBql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946010AbXBIBql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 20:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946003AbXBIBql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 20:46:41 -0500
Received: from ns1.suse.de ([195.135.220.2]:51630 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945999AbXBIBqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 20:46:40 -0500
Date: Fri, 9 Feb 2007 02:46:26 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] fs: add an iovec iterator
Message-ID: <20070209014626.GB17334@wotan.suse.de>
References: <20070208105437.26443.35653.sendpatchset@linux.site> <20070208105446.26443.35864.sendpatchset@linux.site> <20070208194953.GA4118@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070208194953.GA4118@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 07:49:53PM +0000, Christoph Hellwig wrote:
> On Thu, Feb 08, 2007 at 02:07:24PM +0100, Nick Piggin wrote:
> > Add an iterator data structure to operate over an iovec. Add usercopy
> > operators needed by generic_file_buffered_write, and convert that function
> > over.
> 
> iovec_iterator is an awfully long and not very descriptive name.
> In past discussions we named this thingy iodesc and wanted to pass it
> down all the I/O path, including the file operations.

Hi Christoph,

Sure I think it would be a good idea to shorten the name. And yes, although
I just construct the iterator to pass into perform_write, I think it should
make sense to go much further up the call stack instead of passing all those
args around. iodesc seems like a fine name, so I'll use that unless
anyone objects.


Thanks,
Nick
