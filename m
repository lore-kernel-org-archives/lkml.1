Return-Path: <linux-kernel-owner+w=401wt.eu-S1752394AbZKDGfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbZKDGfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbZKDGfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:35:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253AbZKDGfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:35:42 -0500
Date: Tue, 3 Nov 2009 22:34:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
Message-Id: <20091103223433.23765578.akpm@linux-foundation.org>
In-Reply-To: <1257234299.28469.25.camel@johannes.local>
References: <20091103053156.GA3212@core.coreip.homeip.net>
	<20091102.224957.32364226.davem@davemloft.net>
	<20091103065238.GE3212@core.coreip.homeip.net>
	<1257232587.3420.55.camel@localhost.localdomain>
	<1257234299.28469.25.camel@johannes.local>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Nov 2009 08:44:59 +0100 Johannes Berg <johannes@sipsolutions.net> wrote:

> On Tue, 2009-11-03 at 16:16 +0900, Marcel Holtmann wrote:
> 
> > and can we please stop jumping the gun here and going past the subsystem
> > maintainers. I think this happens a little bit too much lately.
> 
> I'll rant a bit too -- I've been very annoyed by this many times.

Problem is, subsystem maintainers are very unreliable.

Right now I'm sitting on 17 patches which I think should be in 2.6.32,
which I need to plead with subsystem maintainers to take a look at. 
They've already seen the patches (usually at least twice) and they've
just blown them off.  This is typical.

And then there are the 100 to 200 non-critical patches which I'm always
sitting on, similarly ignored.  And I'm increasingly just ignoring
stuff nowadays because this situation is so bad.

And then there are all the bug reports which flow in one ear and out
the other.

Now, some subsystem maintainer are good, and some aren't.  I'm probably
the only person who could write the detailed list for each column. 
Unfortunately, people who have better lives than me are best off
assuming that a subsystem maintainer is unreliable.  If the problem is
severe enough, bypassing the maintainer is a sensible default.

