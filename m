Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbZASTNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbZASTNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 14:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbZASTNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 14:13:40 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41373 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbZASTNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 14:13:39 -0500
Date: Sun, 18 Jan 2009 18:40:35 +0100
From: Pavel Machek <pavel@suse.cz>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org
Subject: Re: Warning and BUG with btrfs and corrupted image
Message-ID: <20090118174035.GG1944@ucw.cz>
References: <20090113142147.GE16333@alice> <1231857643.29164.28.camel@think.oraclecorp.com> <20090113144307.GF16333@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113144307.GF16333@alice>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-01-13 15:43:07, Eric Sesterhenn wrote:
> * Chris Mason (chris.mason@oracle.com) wrote:
> > On Tue, 2009-01-13 at 15:21 +0100, Eric Sesterhenn wrote:
> > > Hi,
> > > 
> > > when mounting an intentionally corrupted btrfs filesystem i get the
> > > following warning and bug message. The image can be found here
> > > www.cccmz.de/~snakebyte/btrfs.2.img.bck.bz2
> > 
> > Thanks for looking at things
> > 
> > Aside from catching checksumming errors, we're not quite ready for
> > fuzzer style attacks.  The code will be hardened for this but it isn't
> > yet.
> 
> Does this mean i should stop trying to break it for now or are you interested
> in further reports?

Does ext2/3 and vfat survive that kind of attacks? Those are 'in
production' and should survive it...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
