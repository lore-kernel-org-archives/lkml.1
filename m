Return-Path: <linux-kernel-owner+w=401wt.eu-S933328AbXHVSPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328AbXHVSPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763680AbXHVSPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:15:39 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:52701 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759745AbXHVSPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:15:37 -0400
Date: Wed, 22 Aug 2007 19:15:32 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Chris Wedgwood <cw@f00f.org>, Adrian Bunk <bunk@kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jarek Poplawski <jarkao2@o2.pl>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: RFC: drop support for gcc < 4.0
Message-ID: <20070822181532.GB3362@linux-mips.org>
References: <20070821132038.GA22254@ff.dom.local> <20070821093103.3c097d4a.randy.dunlap@oracle.com> <20070821173550.GC30705@stusta.de> <20070821182505.GA20968@puku.stupidest.org> <5d6222a80708211341s63f8c1eau922f018e66db49f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d6222a80708211341s63f8c1eau922f018e66db49f4@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 05:41:04PM -0300, Glauber de Oliveira Costa wrote:

> Last time I tried a mips build, it would fail the compile unless I was
> using _exactly_ 3.4.4 (I didn't tried older versions, but did try
> 3.4.6, for ex.). So I also think the 3.4 series will still have to be
> around for a while.

I don't know what broken MIPS platform you've tried.  I keep changing
between compiler versions all the time just so I can ensure builds with
older compilers keep working until we officially deciede to drop support
for them.  So the minimum compiler version for 32-bit MIPS kernels is
gcc 3.2 and for 64-bit kernel gcc 3.3.

But for sake of sanity and productivity I definately don't mind dumping
support for gcc < 4.0 or maybe even 4.1.  And while we're at it, let's
deprecate ancient binutils version as well.  A minimum version of 2.17
would be nice as I could get rid of lads of .word sillyness which is
needed to support older binutils.

  Ralf
