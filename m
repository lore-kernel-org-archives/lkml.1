Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbYGXTt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbYGXTt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 15:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYGXTtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 15:49:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41603 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYGXTtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 15:49:16 -0400
Date: Thu, 24 Jul 2008 15:49:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] remove <linux/hdreg.h>
Message-ID: <20080724194915.GA23998@infradead.org>
References: <200807242137.58606.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807242137.58606.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 09:37:58PM +0200, Bartlomiej Zolnierkiewicz wrote:
> It has no in-kernel users now and can be removed.

But beeing an exported header it has userspace users.  Plese keep it
and just leave the ioctl defintions as need by userspace in it instead
of renaming that part to hdio_ioctls.h.

