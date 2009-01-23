Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbZAWAGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbZAWAGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 19:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbZAWAGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 19:06:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51854 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbZAWAGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 19:06:31 -0500
Date: Thu, 22 Jan 2009 19:06:17 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Eric Sesterhenn <snakebyte@gmx.de>, Pavel Machek <pavel@suse.cz>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       npiggin@yahoo.com.au, xfs@oss.sgi.com
Subject: Re: [PATCH] Re: Corrupted XFS log replay oops.
Message-ID: <20090123000617.GB4970@infradead.org>
References: <20090113142147.GE16333@alice> <20090120173455.GC21339@alice> <20090121035703.GH10158@disturbed> <200901211503.07308.nickpiggin@yahoo.com.au> <20090122043747.GU10158@disturbed> <20090122061158.GA31104@infradead.org> <20090123000203.GC32390@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090123000203.GC32390@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [XFS] Check buffer lengths in log recovery
> 
> Before trying to obtain, read or write a buffer,
> check that the buffer length is actually valid. If
> it is not valid, then something read in the recovery
> process has been corrupted and we should abort
> recovery.
> 
> Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Tested-by: Eric Sesterhenn <snakebyte@gmx.de>


Reviewed-by: Christoph Hellwig <hch@lst.de>

