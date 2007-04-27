Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbXD0MbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbXD0MbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755757AbXD0MbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:31:07 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:43670 "EHLO
	amsfep12-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755750AbXD0MbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:31:04 -0400
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
	FS is under heavy write load (massive starvation)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Marat Buharov <marat.buharov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Galbraith <efault@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
In-Reply-To: <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	 <20070427013350.d0d7ac38.akpm@linux-foundation.org>
	 <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 14:30:58 +0200
Message-Id: <1177677058.28223.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 15:59 +0400, Marat Buharov wrote:
> On 4/27/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > Aside: why the heck do applications think that their data is so important
> > that they need to fsync it all the time.  I used to run a kernel on my
> > laptop which had "return 0;" at the top of fsync() and fdatasync().  Most
> > pleasurable.
> 
> So, if having fake fsync() and fdatasync() is pleasurable for laptop
> and desktop, may be it's time to add option into Kconfig which
> disables normal fsync behaviour in favor of robust desktop?

Nah, just teaching user-space to behave themselves should be sufficient;
there is just no way kicker can justify doing a fdatasync(), I mean,
come on its just showing a friggin menu. I have always wondered why that
thing was so damn slow, like it needs to fetch stuff like that from all
four corners of disk, feh!

Just sliding over a sub-menu can take more than a second; I mean, it
_really_ is just faster to just start things from your favourite shell.

No way is globally disabling fsync() a good thing. I guess Andrew just
is a sucker for punishment :-)


