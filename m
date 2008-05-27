Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbYE0DwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbYE0DwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 23:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbYE0DwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 23:52:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36255 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbYE0DwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 23:52:10 -0400
Date: Mon, 26 May 2008 20:49:14 -0700
From: Greg KH <greg@kroah.com>
To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Message-ID: <20080527034914.GA20295@kroah.com>
References: <4836EE8C.1010200@linux.intel.com> <20080524222304.GD20563@atrey.karlin.mff.cuni.cz> <20080524153020.1df96cf2@linux.intel.com> <20080524224554.GA5970@mit.edu> <20080526093913.GG13529@elte.hu> <20080526101646.GD24507@mit.edu> <20080526104832.GG23261@elte.hu> <20080526162048.GH32407@duck.suse.cz> <20080526164858.GA24098@elte.hu> <20080526170147.GB9893@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526170147.GB9893@mit.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 01:01:48PM -0400, Theodore Tso wrote:
> On Mon, May 26, 2008 at 06:48:58PM +0200, Ingo Molnar wrote:
> > 
> > What if the USB stick was pulled mistakenly, the user notices her 
> > mistake later on and plugs the USB stick back in and expects all the 
> > data to not be corrupted?
> 
> If the USB stack folks would like to work on how to recognize that
> it's the same USB stick that had been previously pulled, so that it
> gets the same block device, and we can decide for how long we should
> keep dirty buffers around associated with a pulled USB stick, we can
> certainly have that conversation.  :-)

We do that already on suspend/resume, so it should not be hard to move
that to a disconnect/connect model as well, it's the same code path :)

Bring it up on the linux-usb list if you are interested in persuing
this.

In the meanwhile, getting rid of the warning would be a good idea.

thanks,

greg k-h
