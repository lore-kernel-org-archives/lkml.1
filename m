Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbYBQWQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbYBQWQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 17:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbYBQWQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 17:16:20 -0500
Received: from qult.net ([82.238.217.46]:57450 "EHLO slartibartfast.qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816AbYBQWQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 17:16:19 -0500
Date: Sun, 17 Feb 2008 23:16:03 +0100
From: Ignacy Gawedzki <lkml@qult.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kernel BUG at mm/rmap.c:631!
Message-ID: <20080217221603.GA32482@zenon.in.qult.net>
Mail-Followup-To: Ignacy Gawedzki <lkml@qult.net>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20080217194427.GA1080@zenon.in.qult.net> <200802172116.37205.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802172116.37205.rjw@sisk.pl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 09:16:36PM +0100, thus spake Rafael J. Wysocki:
> On Sunday, 17 of February 2008, Ignacy Gawedzki wrote:
> > Hi,
> 
> Hi,
> 
> > I was printing on the parallel port and suddenly the "parallel" CUPS backend
> > went 50% CPU (obviously endless-looping), while the other 50% were eaten by
> > ghostscript (strace didn't show anything, so this might be an "internal"
> > loop).  When I eventually killed the latter, I got this:
> 
> Which kernel is this?

As is shown in the dmesg, it is 2.6.24.1.

>                        Is it a regression?

Can't really say for sure.  At least it already happened with 2.6.23.9.

>                                             If so, what's the last known
> working kernel?

This is really difficult to determine, since the event is pretty hard to
reproduce.  I'll try to investigate more, then. :/  This one happened pretty
much right after a reboot due to a completely frozen machine (no Oops or Eeek
whatsoever) apparently due to intensive writing to the parallel port (the
kernel complained that "FIFO write timed out" twice before locking up).

Of course I do suspect a hardware problem, but since last time I had similarly
strange things it ended up being due to misconfiguration, I still hope
someone will tell me this is also the case here.

-- 
:wq!
