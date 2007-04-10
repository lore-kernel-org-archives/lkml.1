Return-Path: <linux-kernel-owner+w=401wt.eu-S1031008AbXDJQOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031008AbXDJQOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031009AbXDJQOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:14:25 -0400
Received: from verein.lst.de ([213.95.11.210]:39762 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031008AbXDJQOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:14:24 -0400
Date: Tue, 10 Apr 2007 18:14:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@lst.de>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cleanup compat ioctl handling
Message-ID: <20070410161427.GA15895@lst.de>
References: <20070410112857.GA4581@lst.de> <p73fy78jgut.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73fy78jgut.fsf@bingen.suse.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 07:10:02PM +0200, Andi Kleen wrote:
> Christoph Hellwig <hch@lst.de> writes:
> 
> > Merge all compat ioctl handling into compat_ioctl.c instead of splitting
> > it over compat.c and compat_ioctl.c.  This also allows to get rid of
> > ioctl32.h
> 
> Looks good. 
> 
> If someone feels the need to do more cleanup here -- it would be also
> nice to move more handlers to be in ->compat_ioctl and in their respective
> files than so much compat_ioctl.

Arnd had a huge patch series for that that somehow got lost.  It would
be nice if someone with a little time on his hands could revive parts of
it.

