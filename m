Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbZH3CuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbZH3CuW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 22:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZH3CuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 22:50:22 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46105 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbZH3CuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 22:50:21 -0400
Date: Sat, 29 Aug 2009 20:50:22 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Mark Lord <liml@rtr.ca>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, dwmw2@infradead.org
Subject: Re: [PATCH 6/7] block: allow large discard requests
Message-ID: <20090830025022.GE22870@parisc-linux.org>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829231122.302813585@bombadil.infradead.org> <4A99E89E.9020204@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A99E89E.9020204@rtr.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 29, 2009 at 10:49:02PM -0400, Mark Lord wrote:
> Pardon my cursory review, but I don't see where this
> patch set allows for more than a single extent/range
> of sectors per TRIM command.

It doesn't.

> If it still does not group many extents into a single TRIM,
> then it will be far to slow to be useful at all for SATA.

That depends on the firmware.  I do have plans to group the extents,
but let's get something working before making it quick.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
