Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbYJTU4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbYJTU4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 16:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbYJTU4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 16:56:38 -0400
Received: from smtp.nokia.com ([192.100.105.134]:23144 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbYJTU4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 16:56:37 -0400
Date: Mon, 20 Oct 2008 23:54:00 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Greg KH <greg@kroah.com>
Cc: Willy Tarreau <w@1wt.eu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Steven Noonan <steven@uplinklabs.net>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081020205400.GB26744@gandalf.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com> <f488382f0810170116qd7e1845h8942c195352934d1@mail.gmail.com> <20081017174657.GH2221@kroah.com> <20081017204723.15114eaa@lxorguk.ukuu.org.uk> <20081017214409.GB3585@kroah.com> <20081018084504.GQ24654@1wt.eu> <20081020203033.GB20788@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020203033.GB20788@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 20 Oct 2008 20:54:05.0853 (UTC) FILETIME=[FD857CD0:01C932F5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 01:30:33PM -0700, Greg KH wrote:
> > IMHO, having a small number of small digits is the way to go. Using
> > 1 or 2 digits for the major and 1 for the minor is fine. After 3.9, you
> > go to version 4.0. Anyway, there are so many changes between versions
> > these days that any new versions could justify a major change (eg:
> > check the size of the 2.6.27 patch).
> > 
> > With versions from 1.1 to 9.9, you can go as high as 88 versions,
> > which is about 22 years of development at current pace. After that,
> > we can simply turn to 10.0 and not break anything.
> > 
> > It's also easier for users. Check how many non-kernel techies around you
> > know all 3 digits of the version they use. It's easier to remember 4.3
> > than it is to remember 2.6.27.
> 
> I agree that would be nicer, and easier for everyone.

It's true it would be easier for tracking down and remembering the
version number, but on the other hand, the good thing about this
version number system is that we now 2.6.xx is a rather stable and
complete kernel tree and when we move to 2.7, we know it'll be the start
for the 2.8 kernel series.

Just like the migration from 2.4 to 2.5.

Also, changing now the version numbering would be troublesome as well.
Most of the users/developers who tracks linux-2.6.git are used to
have 3 levels of version number.

Still, it's nice to start thinking about it now since we're getting
closer to last sublevel of 2.4 series (i think it was 2.4.37 ??) and try
to find a new scheme for version numbering before thinking about 2.7 (or
3.0 ??) series.

-- 
balbi
