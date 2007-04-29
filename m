Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbXD2ONU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbXD2ONU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 10:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756495AbXD2ONT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 10:13:19 -0400
Received: from waste.org ([66.93.16.53]:57341 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497AbXD2ONS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 10:13:18 -0400
Date: Sun, 29 Apr 2007 09:12:47 -0500
From: Matt Mackall <mpm@selenic.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070429141247.GO11166@waste.org>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <20070426142846.45ee23af@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426142846.45ee23af@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 02:28:46PM +0100, Alan Cox wrote:
> > > Oh we have scores of these hacks around. Look at the dvd/cd layer. The 
> > > point is to get rid of those.
> > 
> > Perhaps this is just a matter of cleaning them up so they are no
> > longer hacks?
> 
> CD and DVD media support various non power-of-two block sizes. Supporting
> more block sizes would also be useful as we could then read older smart
> media (256byte/sector) without the SCSI layer objecting and the like.

Non-power-of-two block sizes are also desirable for FLASH, where
things like UBI want to stash metadata in parts of eraseblocks. 

(I've suggested to the MTD folks that it could be made to work with the
block layer, but their imaginations couldn't seem to get much beyond
"erase blocks aren't sector-sized".)

-- 
Mathematics is the supreme nostalgia of our time.
