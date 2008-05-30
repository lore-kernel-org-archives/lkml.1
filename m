Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbYE3HcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbYE3HcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 03:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbYE3Hb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 03:31:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41072 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYE3Hb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 03:31:57 -0400
Date: Fri, 30 May 2008 03:31:49 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Rik van Riel <riel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Xiaoming Li <forrubm2@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [help]How to block new write in a "Thin Provisioning" logical
	volume manager as a virtual device driver when physical spaces run
	out?
Message-ID: <20080530073149.GA7758@infradead.org>
References: <5f7c1d2c0805290212i45aece46j7fae2dcf9c158b92@mail.gmail.com> <20080529113159.113a7f06@core> <20080529120815.177bd456@bree.surriel.com> <20080529230441.GB5134@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529230441.GB5134@disturbed>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 09:04:41AM +1000, Dave Chinner wrote:
> > In a block based thin provisioning system, like you proposed, there
> > is no way to free up space.  Once a user's filesystem has written a
> > block, it is allocated - when the user deletes a file inside the
> > filesystem, the space will not be freed again...
> 
> That's where we've been discussing bio hints to help communicate
> space being allocated and freed by the filesystem to the lower layers.

Or use the XFS multiple subvolume support based on that:

http://verein.lst.de/~hch/xfs/xfs-multiple-containers.txt

and yeah, I really need to finish the lose bits up and actually post it.
Hopefully next month.

