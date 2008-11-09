Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbYKIUOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbYKIUOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbYKIUOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 15:14:05 -0500
Received: from mail.fieldses.org ([66.93.2.214]:45961 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243AbYKIUOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 15:14:04 -0500
Date: Sun, 9 Nov 2008 15:13:57 -0500
To: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, lkml <linux-kernel@vger.kernel.org>,
       linux-doc@vger.kernel.org, corbet@lwn.net, mtk.manpages@gmail.com,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [RFC] Documentation tree sub-directories reorg.
Message-ID: <20081109201357.GB27376@fieldses.org>
References: <4910D1BC.9060100@xenotime.net> <200811071313.50384.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811071313.50384.rob@landley.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 01:13:49PM -0600, Rob Landley wrote:
> On Tuesday 04 November 2008 16:50:36 Randy Dunlap wrote:
> > Hi,
> >
> > I would like to use a few more sub-directories in the Documentation/ tree
> > to try to help clean it up some.  E.g., move some drivers/block/ doc files
> > to Documentation/blockdev/ and move some serial/tty/chardev doc files to
> > Documentation/serial/  (or serial-tty/ or chardev/ or <suggestions>).
> >
> >
> > A [git] diff for blockdev/ and serial/ looks like:
> ...
> > Comments/thoughts?
> 
> That's a good start.  It would also be nice to create an "arch" subdirectory 
> to move the arm, m68k, mips, blackfin, parisc, powerpc, s390, sparc, ia64, 
> uml, and x86 directories into.  (Plus sgi-*, voyager.txt, zorro.txt...)

I started doing some of this here:

	git://linux-nfs.org/~bfields/linux.git for-joncorbet

but didn't get very far.  (But in the remote chance there's something
useful there, feel free to cannibalize it.)

--b.
