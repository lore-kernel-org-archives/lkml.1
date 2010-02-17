Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845Ab0BQJZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 04:25:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40082 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab0BQJZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 04:25:46 -0500
Date: Wed, 17 Feb 2010 04:25:45 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Taylor <Daniel.Taylor@wdc.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 4K disk block and disks larger than 2TiB bugs
Message-ID: <20100217092545.GA16508@infradead.org>
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD0A@wdscexbe01.sc.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD0A@wdscexbe01.sc.wdc.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 08:14:27PM -0800, Daniel Taylor wrote:
> The larger problem is for EFI.  There is a significant amount of hard-coded
> assumption that LBAs are 512 bytes.  It would help if I could work with the
> designer to make (and test) the changes in a way that abstracts away the
> size (I do know that the kernel always thinks of disks in units of 512-byte
> blocks).  I have seen attempts in the past to fix this problem, but the
> patches
> were rejected with erroneous comments about fixing it in user space.  If the
> kernel will not recognise the partitions, or assigns incorrect values to the
> starting block and/or number of blocks, there is nothing that user space can
> do with the disk, except notice the EINVAL responses.

This should be fixed since commit 7d13af3279985f554784a45cc961f706dbcdbdd1,
which is included in Linux 2.6.32.

