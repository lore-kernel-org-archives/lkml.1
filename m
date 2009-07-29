Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbZG2PHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbZG2PHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 11:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbZG2PHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 11:07:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54150 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbZG2PHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 11:07:23 -0400
Date: Wed, 29 Jul 2009 17:07:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Andreas Dilger <adilger@sun.com>,
       device-mapper development <dm-devel@redhat.com>,
       Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
Message-ID: <20090729150716.GG1534@ucw.cz>
References: <19041.4714.686158.130252@notabene.brown> <20090718043155.GI4231@webber.adilger.int> <871voewm6y.fsf@basil.nowhere.org> <20090718065213.GK4231@webber.adilger.int> <20090718074811.GA2682@basil.fritz.box> <20090718134946.GA25546@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090718134946.GA25546@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Also, for filesystems like btrfs or ZFS the checking can be done
> > > online and incrementally without storing a full representation of
> > > the state in memory.
> > 
> > You could, but I suspect it would be cheaper to just use a
> > 64bit system than to rewrite fsck. 64bit is available
> > for a lot of embedded setups these days too.
> 
> We don't have to rewrite fsck; most of the framework for supporting an
> run-length-conding for compressed bitmaps is already in patches that
> add > 32-bit block numbers to e2fsprogs; we've just been more focused
> on getting 64-bit block numbers support merged than implementing
> compressed bitmaps, but it's only one file that would need to be
> added, and we might be able to steal the compressed bitmap support
> from xfsprogs --- which does this already.

Well... 'If allocation pattern is bad your fsck runs out of address
space and breaks on your 15T fs' would scare me.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
