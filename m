Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYIVRhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYIVRhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 13:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYIVRhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 13:37:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174AbYIVRhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 13:37:19 -0400
Date: Mon, 22 Sep 2008 10:36:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Krishna Kumar <krkumar2@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: do_generic_file_read() never gets a NULL 'filp'
 argument
Message-Id: <20080922103635.77d795e4.akpm@linux-foundation.org>
In-Reply-To: <20080922083945.GA12658@infradead.org>
References: <20080922061610.20158.86022.sendpatchset@localhost.localdomain>
	<20080922013338.8e1c10ff.akpm@linux-foundation.org>
	<20080922083945.GA12658@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 04:39:46 -0400 Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Sep 22, 2008 at 01:33:38AM -0700, Andrew Morton wrote:
> > On Mon, 22 Sep 2008 11:46:10 +0530 Krishna Kumar <krkumar2@in.ibm.com> wrote:
> > 
> > > From: Krishna Kumar <krkumar2@in.ibm.com>
> > > 
> > > The 'filp' argument to do_generic_file_read() is never NULL.
> > > 
> > 
> > How did you verify this?
> > 
> > NFS used to like passing NULL file*'s into VFS functions.  I don't
> > recall whether it affected do_generic_file_read().
> 
> The only thing nfsd passed a NULL file pointer in is ->fsync on
> directories.

NFS, not NFSD.  It was page_cache_read(), iirc.

