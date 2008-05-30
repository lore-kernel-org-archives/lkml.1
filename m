Return-Path: <linux-kernel-owner+w=401wt.eu-S1760927AbYE3ENg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbYE3ENg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbYE3EB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:01:28 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:42741 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159AbYE3EBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:01:18 -0400
Date: Thu, 29 May 2008 21:08:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Chris Frey <cdfrey@foursquare.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [next-20080529] build error: missing ieee80211_tx_control?
Message-Id: <20080529210841.f3e8c4a8.randy.dunlap@oracle.com>
In-Reply-To: <20080530034225.GA5238@foursquare.net>
References: <20080530001525.GA29604@foursquare.net>
	<20080529194506.336077d8.randy.dunlap@oracle.com>
	<20080530034225.GA5238@foursquare.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 23:42:25 -0400 Chris Frey wrote:

> On Thu, May 29, 2008 at 07:45:06PM -0700, Randy Dunlap wrote:
> > On Thu, 29 May 2008 20:15:25 -0400 Chris Frey wrote:
> > >   CC      drivers/input/serio/serio.o
> > >   CC      drivers/input/serio/i8042.o
> > > In file included from drivers/input/serio/i8042.h:28,
> > >                  from drivers/input/serio/i8042.c:85:
> > > drivers/input/serio/i8042-x86ia64io.h: In function 'i8042_platform_init':
> > > drivers/input/serio/i8042-x86ia64io.h:590: error: 'i8042_nopnp' undeclared (first use in this function)
> > > drivers/input/serio/i8042-x86ia64io.h:590: error: (Each undeclared identifier is reported only once
> > > drivers/input/serio/i8042-x86ia64io.h:590: error: for each function it appears in.)
> > > make[2]: *** [drivers/input/serio/i8042.o] Error 1
> > > make[1]: *** [drivers/input/serio] Error 2
> > > make: *** [drivers] Error 2
> > 
> > Please see this thread for patches:
> >   http://lkml.org/lkml/2008/5/29/299
> 
> Thanks.  I applied the second patch in that thread, and it gets past
> the serio.o module.
> 
> I realize this is not related to serio anymore, but now it stops here,
> using the same config as in my previous email.  This is just a general
> build report... I don't expect you to fix it personally. :-)
> 
> I can't seem to find ieee80211_tx_control anywhere in the tree, except in
> pio.h.
> 
> 
>   CC      drivers/net/wireless/airo.o
>   CC      drivers/net/wireless/b43legacy/main.o
> In file included from drivers/net/wireless/b43legacy/main.c:51:
> drivers/net/wireless/b43legacy/pio.h:134: warning: 'struct ieee80211_tx_control' declared inside parameter list
> drivers/net/wireless/b43legacy/pio.h:134: warning: its scope is only this definition or declaration, which is probably not what you want
> drivers/net/wireless/b43legacy/main.c: In function 'b43legacy_op_tx':
> drivers/net/wireless/b43legacy/main.c:2375: error: too few arguments to function 'b43legacy_pio_tx'
> make[4]: *** [drivers/net/wireless/b43legacy/main.o] Error 1
> make[3]: *** [drivers/net/wireless/b43legacy] Error 2
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2

Patch is here:  http://marc.info/?l=linux-next&m=121165255717756&w=2


---
~Randy
"He closes his eyes and drops the goggles.  You can't get hurt
by looking at a bitmap.  Or can you?"
