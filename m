Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbZFZWTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbZFZWTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZFZWSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:18:53 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:47475 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbZFZWSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:18:52 -0400
Date: Sat, 27 Jun 2009 00:21:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>, benh@kernel.crashing.org,
       paulus@samba.org
Subject: Re: [PATCH] gitignore: add *.bz2 and *.cpio to top-level; clean up usr/
Message-ID: <20090626222112.GB27048@uranus.ravnborg.org>
References: <200906202056.n5KKuc9o013960@tazenda.hos.anvin.org> <1245569547.2480.18.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245569547.2480.18.camel@ht.satnam>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 21, 2009 at 01:02:27PM +0530, Jaswinder Singh Rajput wrote:
> 
> On Sat, 2009-06-20 at 13:52 -0700, H. Peter Anvin wrote:
> > Add *.bz2 and *.cpio to the top-level gitignore file, for consistency
> > with *.gz and *.lzma which are already there.  Remove specific rules
> > in usr/gitignore, since they are now covered by the global rules.
> > 
> > Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> 
> It seems this is based on my patch :
> 
> [PATCH] gitignore usr/initramfs_data.cpio.bz2 and usr/initramfs_data.cpio.lzma
> 
> And you forget to CC me ;-)
> 
> Are you trying to do this, fill signed-off-by and enjoy :
> 
> [PATCH] Add *.bz2 and *.cpio to the top-level gitignore file, for consistency
>  with *.gz and *.lzma which are already there.  Remove specific rules
>  in other gitignores, since they are now covered by the global rules.

I would prefer to have *.gz and *.lzma pushed out to the
directories where it matters.
There global ignore rules will bite us one day.

So I did not apply neither this nor Peter's original patch.

	Sam
