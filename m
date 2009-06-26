Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbZFZWlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbZFZWlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbZFZWlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:41:02 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:50459 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbZFZWlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:41:01 -0400
Date: Sat, 27 Jun 2009 00:43:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>, benh@kernel.crashing.org,
       paulus@samba.org
Subject: Re: [PATCH] gitignore: add *.bz2 and *.cpio to top-level; clean up usr/
Message-ID: <20090626224321.GA27310@uranus.ravnborg.org>
References: <200906202056.n5KKuc9o013960@tazenda.hos.anvin.org> <1245569547.2480.18.camel@ht.satnam> <20090626222112.GB27048@uranus.ravnborg.org> <4A454A69.4050301@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A454A69.4050301@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 03:23:37PM -0700, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> > 
> > I would prefer to have *.gz and *.lzma pushed out to the
> > directories where it matters.
> > There global ignore rules will bite us one day.
> > 
> > So I did not apply neither this nor Peter's original patch.
> > 
> 
> I think that's the wrong answer, unless we somehow end up with
> compressed files in the source.  At the moment, a *.gz file in the
> source tree is much more likely to be a file in use by the developer.

My concern is that we may decide to carry files in certain formats
in the kernel source.
And I see a tendency to add more and more file extensions to the
top-level .gitignore file.

It is fine as long as this is files that are:
1) either generated in a lot of places
2) or generated in the top-level directory

But files that we generate in a few arch/*/boot/ directories
does not belong in the top-level .gitignore file.
We should keep the ignore rules close to where they apply,
even if this may cause us to add a few more lines
to the relevant .gitignore files.

	Sam
