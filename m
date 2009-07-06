Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbZGFRX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbZGFRX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 13:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbZGFRXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 13:23:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56776 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbZGFRXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 13:23:42 -0400
Date: Mon, 6 Jul 2009 13:23:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 2/3] fs: make use of new helper functions
Message-ID: <20090706172345.GB26042@infradead.org>
References: <20090706165438.GQ2714@wotan.suse.de> <20090706165522.GR2714@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090706165522.GR2714@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 06:55:22PM +0200, Nick Piggin wrote:
> 
> Update some fs code to make use of new helper functions introduced
> in the previous patch. Should be no significant change in behaviour
> (except CIFS now calls send_sig under i_lock, via inode_truncate_ok).
> 
> ---
>  fs/buffer.c           |   10 +--------
>  fs/cifs/inode.c       |   51 ++++++++-----------------------------------------
>  fs/fuse/dir.c         |   13 +++---------
>  fs/fuse/fuse_i.h      |    2 -
>  fs/fuse/inode.c       |   10 ---------
>  fs/nfs/inode.c        |   52 +++++++++++---------------------------------------
>  fs/ramfs/file-nommu.c |   18 ++++-------------
>  7 files changed, 33 insertions(+), 123 deletions(-)

Nice cleanup.  I would recommend moving the introduction of those
helpers to this patch and make it the first in the series.
