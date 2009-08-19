Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbZHSQLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbZHSQLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbZHSQLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:11:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33594 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbZHSQLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:11:45 -0400
Date: Wed, 19 Aug 2009 12:11:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@infradead.org,
       Evgeniy Polyakov <zbr@ioremap.net>, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>
Subject: Re: [PATCH 02/17] vfs: Export __generic_file_aio_write() and add
	some comments
Message-ID: <20090819161145.GB6150@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <1250697884-22288-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250697884-22288-3-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 06:04:29PM +0200, Jan Kara wrote:
> Rename __generic_file_aio_write_nolock() to __generic_file_aio_write(), add
> comments to write helpers explaining how they should be used and export
> __generic_file_aio_write() since it will be used by some filesystems.

The renaming and commenting looks good to me, and the export is fine
with me given that we'll actually use it later one.


Reviewed-by: Christoph Hellwig <hch@lst.de>

Can we maybe get rid of generic_file_aio_write_nolock after you patch
series?

