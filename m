Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592Ab0ABVG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab0ABVG7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 16:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369Ab0ABVG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 16:06:58 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34741 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab0ABVG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 16:06:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BxroIWEWC79OcmE5ekVI4uL0e1vyz/4IwU8s3523YPbz3M8X2fZPSYL3m/IcyusC06
         M1Ou0t9NgOsH9uBefP9Qtnatof8Canh1D9zgg6cdG17mrhsnWOTV4vwFkBy8S+sZwhvY
         htdyFxvSlhWtjkJ3dvfy9+lo7Ck+QzD3VpFdQ=
Date: Sat, 2 Jan 2010 22:06:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: tytso@mit.edu
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: reiserfs broken in 2.6.32 was Re: [GIT PULL] reiserfs fixes
Message-ID: <20100102210653.GH5076@nowhere>
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com> <87bphc7heo.fsf@basil.nowhere.org> <20100102163644.GA5076@nowhere> <20100102174311.GA30016@basil.fritz.box> <20100102190213.GC5076@nowhere> <20100102192337.GB30016@basil.fritz.box> <20100102201138.GF5076@nowhere> <20100102210101.GN828@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100102210101.GN828@thunk.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 02, 2010 at 04:01:01PM -0500, tytso@mit.edu wrote:
> On Sat, Jan 02, 2010 at 09:11:39PM +0100, Frederic Weisbecker wrote:
> > 
> > I've never lost any datas since I began this work. And
> > I run it every day. If I had experienced lock inversions,
> > and sometimes soft lockups, I did not experienced serious
> > damages. It's a journalized filesystem that can fixup the things
> > pretty well.
> 
> Have you tried using the xfsqa regression test suite?  Despite the
> name, it will work on non-xfs filesystems (although there are some
> XFS-specific tests in the test suite.)  Both the btrfs and ext4
> developers use it to debug their file systems, and it's a good way of
> stressing the file system in all sorts of different ways that might
> not be seen during normal desktop usage.  I suspect it would be a good
> way of flushing out potential problems for reiserfs as well.
> 
> Regards,


Thanks! I'm going to test it now. I've been running a stress test
from Chris Mason which basically checks races on parallel writes/read.

If this testsuite includes more checks, like xattr and some other
things, then that's exactly what I was searching.

I guess this is the right place to get it?

git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git

Thanks.

