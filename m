Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbZADW4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbZADW4N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 17:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbZADWz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 17:55:57 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42777 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735AbZADWz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 17:55:56 -0500
X-Greylist: delayed 798 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Jan 2009 17:55:56 EST
Date: Mon, 5 Jan 2009 09:42:33 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Theodore Tso <tytso@mit.edu>, Duane Griffin <duaneg@dghda.com>,
       Valdis.Kletnieks@vt.edu,
       Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090104224233.GA9531@brong.net>
References: <495FEE66.9080903@ribosome.natur.cuni.cz> <e9e943910901031538m24ff9616na2aaf3a57f161655@mail.gmail.com> <495FF9CE.2020908@ribosome.natur.cuni.cz> <e9e943910901031600o1705dfb3j197f90b62d1f75a6@mail.gmail.com> <495FFECB.5040001@ribosome.natur.cuni.cz> <e9e943910901031641x4c900b6ar5d0f50b648584b7b@mail.gmail.com> <15786.1231041158@turing-police.cc.vt.edu> <e9e943910901040624y69c01b43p1655c0078b969ea6@mail.gmail.com> <20090104184040.GC17558@mit.edu> <Pine.LNX.4.64.0901042015230.31141@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901042015230.31141@anakin>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 08:21:06PM +0100, Geert Uytterhoeven wrote:
> On Sun, 4 Jan 2009, Theodore Tso wrote:
> > On Sun, Jan 04, 2009 at 02:24:43PM +0000, Duane Griffin wrote:
> > > > Is there a way using md/dm/lvm etc to make the source partition R/O and
> > > > replay the journal onto a CoW snapshop?  Admittedly, not easy to do inside
> > > > the 'mount' command itself, but at least it might be workable for LiveCD R/O
> > > > mounts and forensics work, where you can *tell* beforehand that's what you
> > > > want and can jump through setup games before doing the mount...
> > > 
> > > Yes, something like that is best practice, as I understand it. The
> > > LiveCD init scripts could check whether they are about to R/O mount an
> > > ext[34] filesystem needing recovery and either refuse with a useful
> > > message to the user, or even automatically create and mount a COW
> > > snapshot, as you described. They'd still need to warn the user though,
> > > since things like remounting R/W wouldn't work as expected.
> > 
> > So what's the use case where people want to be able to mount a
> > filesystem needing recovery read/only without running the journal?
> 
> As mentioned before, suspending a laptop (running from hdd), running a live CD,
> and expecting everything to work fine when resuming from hdd?

Any particular reason why suspend doesn't run the journal during
shutdown and leave a clean filesystem?  It shouldn't take that
long surely.

I know it doesn't solve the "it really just crashed" problem, but
you don't tend to unsuspend from a crash anyway.

Bron ( just curious )
