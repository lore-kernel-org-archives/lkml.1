Return-Path: <linux-kernel-owner+w=401wt.eu-S1763086AbXILX2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763086AbXILX2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 19:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762232AbXILX2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 19:28:04 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:32852 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762094AbXILX2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 19:28:01 -0400
Date: Wed, 12 Sep 2007 19:27:16 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Christoph Hellwig <hch@infradead.org>, Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] fs: define file_fsync() even for CONFIG_BLOCK=n
Message-ID: <20070912232716.GB21341@filer.fsl.cs.sunysb.edu>
References: <20070912020610.GA26827@linux-sh.org> <20070912093020.GB32511@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912093020.GB32511@infradead.org>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 10:30:20AM +0100, Christoph Hellwig wrote:
> On Wed, Sep 12, 2007 at 11:06:10AM +0900, Paul Mundt wrote:
> > There's nothing that is problematic for file_fsync() with CONFIG_BLOCK=n,
> > and it's built in unconditionally anyways, so move the prototype out to
> > reflect that. Without this, the unionfs build bails out.
> 
> Unionfs should stop using it instead.
 
We did stop.

Josef 'Jeff' Sipek.

-- 
NT is to UNIX what a doughnut is to a particle accelerator.
