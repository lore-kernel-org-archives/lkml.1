Return-Path: <linux-kernel-owner+w=401wt.eu-S1423288AbXBHTt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423288AbXBHTt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 14:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423282AbXBHTt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 14:49:56 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45538 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423288AbXBHTty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 14:49:54 -0500
Date: Thu, 8 Feb 2007 19:49:53 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] fs: add an iovec iterator
Message-ID: <20070208194953.GA4118@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nick Piggin <npiggin@suse.de>,
	Linux Filesystems <linux-fsdevel@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070208105437.26443.35653.sendpatchset@linux.site> <20070208105446.26443.35864.sendpatchset@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070208105446.26443.35864.sendpatchset@linux.site>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 02:07:24PM +0100, Nick Piggin wrote:
> Add an iterator data structure to operate over an iovec. Add usercopy
> operators needed by generic_file_buffered_write, and convert that function
> over.

iovec_iterator is an awfully long and not very descriptive name.
In past discussions we named this thingy iodesc and wanted to pass it
down all the I/O path, including the file operations.

