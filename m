Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbZFZWcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbZFZWcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbZFZWb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:31:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:35294 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbZFZWb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:31:58 -0400
Subject: Re: [PATCH] gitignore: add *.bz2 and *.cpio to top-level; clean up
 usr/
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>, benh@kernel.crashing.org,
       paulus@samba.org
In-Reply-To: <20090626222112.GB27048@uranus.ravnborg.org>
References: <200906202056.n5KKuc9o013960@tazenda.hos.anvin.org>
	 <1245569547.2480.18.camel@ht.satnam>
	 <20090626222112.GB27048@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 04:01:28 +0530
Message-Id: <1246055488.2988.19.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-27 at 00:21 +0200, Sam Ravnborg wrote:
> On Sun, Jun 21, 2009 at 01:02:27PM +0530, Jaswinder Singh Rajput wrote:
> > 
> > On Sat, 2009-06-20 at 13:52 -0700, H. Peter Anvin wrote:
> > > Add *.bz2 and *.cpio to the top-level gitignore file, for consistency
> > > with *.gz and *.lzma which are already there.  Remove specific rules
> > > in usr/gitignore, since they are now covered by the global rules.
> > > 
> > > Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> > > Cc: Sam Ravnborg <sam@ravnborg.org>
> > 
> > It seems this is based on my patch :
> > 
> > [PATCH] gitignore usr/initramfs_data.cpio.bz2 and usr/initramfs_data.cpio.lzma
> > 
> > And you forget to CC me ;-)
> > 
> > Are you trying to do this, fill signed-off-by and enjoy :
> > 
> > [PATCH] Add *.bz2 and *.cpio to the top-level gitignore file, for consistency
> >  with *.gz and *.lzma which are already there.  Remove specific rules
> >  in other gitignores, since they are now covered by the global rules.
> 
> I would prefer to have *.gz and *.lzma pushed out to the
> directories where it matters.
> There global ignore rules will bite us one day.
> 
> So I did not apply neither this nor Peter's original patch.
> 

Ok and what about :

[PATCH] gitignore usr/initramfs_data.cpio.bz2 and usr/initramfs_data.cpio.lzma

Thanks,
--
JSR

