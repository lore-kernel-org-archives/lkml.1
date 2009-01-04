Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbZADSlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbZADSlE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:41:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbZADSkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:40:52 -0500
Received: from thunk.org ([69.25.196.29]:43083 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbZADSku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:40:50 -0500
Date: Sun, 4 Jan 2009 13:40:40 -0500
From: Theodore Tso <tytso@mit.edu>
To: Duane Griffin <duaneg@dghda.com>
Cc: Valdis.Kletnieks@vt.edu,
       Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090104184040.GC17558@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Duane Griffin <duaneg@dghda.com>, Valdis.Kletnieks@vt.edu,
	Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
	Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com> <20090103222957.GG1666@elf.ucw.cz> <495FEE66.9080903@ribosome.natur.cuni.cz> <e9e943910901031538m24ff9616na2aaf3a57f161655@mail.gmail.com> <495FF9CE.2020908@ribosome.natur.cuni.cz> <e9e943910901031600o1705dfb3j197f90b62d1f75a6@mail.gmail.com> <495FFECB.5040001@ribosome.natur.cuni.cz> <e9e943910901031641x4c900b6ar5d0f50b648584b7b@mail.gmail.com> <15786.1231041158@turing-police.cc.vt.edu> <e9e943910901040624y69c01b43p1655c0078b969ea6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9e943910901040624y69c01b43p1655c0078b969ea6@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 02:24:43PM +0000, Duane Griffin wrote:
> > Is there a way using md/dm/lvm etc to make the source partition R/O and
> > replay the journal onto a CoW snapshop?  Admittedly, not easy to do inside
> > the 'mount' command itself, but at least it might be workable for LiveCD R/O
> > mounts and forensics work, where you can *tell* beforehand that's what you
> > want and can jump through setup games before doing the mount...
> 
> Yes, something like that is best practice, as I understand it. The
> LiveCD init scripts could check whether they are about to R/O mount an
> ext[34] filesystem needing recovery and either refuse with a useful
> message to the user, or even automatically create and mount a COW
> snapshot, as you described. They'd still need to warn the user though,
> since things like remounting R/W wouldn't work as expected.

So what's the use case where people want to be able to mount a
filesystem needing recovery read/only without running the journal?

	   	   	    	      	      	      	  - Ted
