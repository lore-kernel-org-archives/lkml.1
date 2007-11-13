Return-Path: <linux-kernel-owner+w=401wt.eu-S1762984AbXKMSvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762984AbXKMSvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762066AbXKMStH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:49:07 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:53084 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762058AbXKMStE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:49:04 -0500
Date: Tue, 13 Nov 2007 11:49:02 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Mark Lord <liml@rtr.ca>
Cc: Ingo Molnar <mingo@elte.hu>, alsa-devel@alsa-project.org,
       netdev@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, protasnb@gmail.com,
       linux-ide@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071113184902.GG17785@parisc-linux.org>
References: <20071113.033946.114918709.davem@davemloft.net> <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca> <20071113164650.GA28493@elte.hu> <4739E3D0.10201@rtr.ca> <20071113183925.GF17785@parisc-linux.org> <4739F069.6050102@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4739F069.6050102@rtr.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 01:43:53PM -0500, Mark Lord wrote:
> Matthew Wilcox wrote:
> >ie about half what you claim.
> ..
> 
> No, it's from earlier in this very thread:
> 
> Adrian Bunk wrote:
> >git clone \ 
> >git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> ..
> 
> mkdir t
> cd t
> git clone 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> (wait half an hour)
> /usr/bin/du -s linux-2.6
> 522732  linux-2.6

You're assuming that everything in linux-2.6 was downloaded; that's
not true.  Everything in linux-2.6/.git was downloaded; but then you do a
checkout which happens to approximately double the size of the linux-2.6
directory.  If you do git-clone -n, you'll get a closer estimate to the
size of the download.

I suppose git-clone should grow a -v option that it could pass to rsync
to let us find out how many bytes are actually transferred, but i'm
happy to go with 250MB as a close estimate to the amount of data to xfer.

When you compare it to the 60MB tarballs that are published, it's really
not that bad.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
