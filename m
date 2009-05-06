Return-Path: <linux-kernel-owner+w=401wt.eu-S1759484AbZEFTCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484AbZEFTCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 15:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbZEFTCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 15:02:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33444 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZEFTB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 15:01:59 -0400
Date: Wed, 6 May 2009 20:01:10 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jean Delvare <khali@linux-fr.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Nicolas Pitre <nico@cam.org>, Wolfram Sang <w.sang@pengutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the i2c tree with the arm-current
	tree
Message-ID: <20090506190110.GB6897@flint.arm.linux.org.uk>
References: <20090506131031.83f1b04d.sfr@canb.auug.org.au> <20090506071547.GA29466@flint.arm.linux.org.uk> <20090506092559.2d9e53cb@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506092559.2d9e53cb@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 09:25:59AM +0200, Jean Delvare wrote:
> Hi Russell,
> 
> On Wed, 6 May 2009 08:15:48 +0100, Russell King wrote:
> > Since defconfig updates are always going to create lots of noise, and
> > the files are normally out of date, the *only* sensible way to handle
> > updates is to have one tree dealing with them per architecture.
> > 
> > Spreading them across multiple trees and then expecting merges to sort
> > out the resulting mess is unreasonable; they just change far too much
> > when updates happen.  Moreover, defconfig updates should be in their
> > own separate commit and not combined with other changes.
> 
> I fail to see how you can handle configuration option renames
> gracefully with your proposed model.

That's not the point I'm making.  The point I'm making is about the
merge issues which is the BIG and I mean BIG as in 1000ft tall
letters BIG problem with scattering defconfig patches everywhere.

The reality of defconfigs is that they're normally months out of date
with respect to the current kernel, and are occasionally updated by
the platform maintainers on an occasional basis (as has happened with
Nicolas' change which your tree has clashed with.)

I've heard it argued that the only people who should ever touch defconfig
files are the platform maintainers themselves.  What I'm suggesting is
one step closer to sanity than that position - having the arch maintainer
responsible for dealing with all changes to those files, thereby providing
a centralised point for synchronising and co-ordinating all defconfig
updates.

If you think you have a better solution (no, throwing them into your own
I2C tree is NOT a solution - it's a cause of major problems) then please
state it.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
