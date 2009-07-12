Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZGLOrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZGLOrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 10:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbZGLOrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 10:47:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41017 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbZGLOrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 10:47:22 -0400
Date: Sun, 12 Jul 2009 10:47:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Nick Piggin <npiggin@suse.de>, Christoph Hellwig <hch@infradead.org>,
       linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [rfc][patch 3/4] fs: new truncate sequence
Message-ID: <20090712144717.GA18163@infradead.org>
References: <20090707150257.GG2714@wotan.suse.de> <20090707150758.GA18075@infradead.org> <20090707154809.GH2714@wotan.suse.de> <20090707163042.GA14947@infradead.org> <20090708063225.GL2714@wotan.suse.de> <20090708104701.GA31419@infradead.org> <20090708123412.GQ2714@wotan.suse.de> <4A54C435.1000503@panasas.com> <20090709075100.GU2714@wotan.suse.de> <4A59A517.1080605@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A59A517.1080605@panasas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 11:55:51AM +0300, Boaz Harrosh wrote:
> I wish you would split it.
> 
> one - helper to be called by converted file systems
>       (Which just ignores the ATTR_SIZE)
> second - to be set into .setattr which does the simple_setsize + above.
> 
> More clear for FS users like me (and that ugly unmask of ATTR_SIZE)
> 
> or it's just me?

Yeah, that seems be a lot cleaner.  But let's wait until we got
rid of ->truncate for all filesystems to have the bigger picture.

> 
> Thanks
> Boaz
---end quoted text---
