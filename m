Return-Path: <linux-kernel-owner+w=401wt.eu-S1756350AbXJ3URw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbXJ3URw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXJ3URp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:17:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60724 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbXJ3URo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:17:44 -0400
Date: Tue, 30 Oct 2007 13:17:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       bernie@codewiz.org
Subject: Re: [PATCH] Allow auto-destruction of loop devices.
Message-Id: <20071030131729.22f2b4b0.akpm@linux-foundation.org>
In-Reply-To: <1193775171.2651.46.camel@shinybook.infradead.org>
References: <1193612911.2915.80.camel@shinybook.infradead.org>
	<20071030130137.3345ae43.akpm@linux-foundation.org>
	<1193775171.2651.46.camel@shinybook.infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 16:12:51 -0400
David Woodhouse <dwmw2@infradead.org> wrote:

> On Tue, 2007-10-30 at 13:01 -0700, Andrew Morton wrote:
> > Why do we want to do this?
> 
> In general, so that we can automatically allocate loop devices (as with
> losetup -f) and have them disappear when we're done with them.
> 
> In particular, right now, so that we can stop relying on the hackish
> special-case in umount(8) which kills off loop devices which were set up
> by 'mount -oloop'. That means we can stop putting crap in /etc/mtab
> which doesn't belong there, which means it can be a symlink
> to /proc/mounts, which means yet another writable file on the root
> filesystem is eliminated and the 'stateless' folks get happier... and
> OLPC trac #356 can be closed.
> 
> The mount(8) side of that is at
> http://marc.info/?l=util-linux-ng&m=119362955431694&w=2

ooh, I spy a changelog.  Thanks.
