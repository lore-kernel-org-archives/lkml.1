Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbYIJLkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbYIJLkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYIJLko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:40:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40533 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbYIJLko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:40:44 -0400
Date: Wed, 10 Sep 2008 07:40:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] include <linux/fs.h> into linux/ext2_fs.h
Message-ID: <20080910114042.GA15996@infradead.org>
References: <1221045726-5674-1-git-send-email-kirill@shutemov.name> <20080910112709.GA11742@infradead.org> <20080910114011.GB3757@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080910114011.GB3757@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 02:40:12PM +0300, Kirill A. Shutemov wrote:
> On Wed, Sep 10, 2008 at 07:27:09AM -0400, Christoph Hellwig wrote:
> > On Wed, Sep 10, 2008 at 02:22:03PM +0300, Kirill A. Shutemov wrote:
> > > linux/fs.h defines FS_IOC* needed by linux/ext2_fs.h
> > 
> > And who cares?  
> 
> It breaks building pam_mktemp at least.

pam_mktemp should not use <linux/ext2_fs.h>, but rather
<ext2fs/ext2_fs.h>.

