Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbYE3Dnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbYE3Dnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 23:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbYE3Dnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 23:43:46 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:47488 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbYE3Dnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 23:43:45 -0400
X-Originating-Ip: 216.16.235.2
Date: Thu, 29 May 2008 23:42:25 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [next-20080529] build error: missing ieee80211_tx_control?
Message-ID: <20080530034225.GA5238@foursquare.net>
References: <20080530001525.GA29604@foursquare.net> <20080529194506.336077d8.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529194506.336077d8.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.1i
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam (whitelisted),
	SpamAssassin (not cached, score=-16.8, required 5,
	autolearn=not spam, ALL_TRUSTED -1.80, BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: <cdfrey@netdirect.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 07:45:06PM -0700, Randy Dunlap wrote:
> On Thu, 29 May 2008 20:15:25 -0400 Chris Frey wrote:
> >   CC      drivers/input/serio/serio.o
> >   CC      drivers/input/serio/i8042.o
> > In file included from drivers/input/serio/i8042.h:28,
> >                  from drivers/input/serio/i8042.c:85:
> > drivers/input/serio/i8042-x86ia64io.h: In function 'i8042_platform_init':
> > drivers/input/serio/i8042-x86ia64io.h:590: error: 'i8042_nopnp' undeclared (first use in this function)
> > drivers/input/serio/i8042-x86ia64io.h:590: error: (Each undeclared identifier is reported only once
> > drivers/input/serio/i8042-x86ia64io.h:590: error: for each function it appears in.)
> > make[2]: *** [drivers/input/serio/i8042.o] Error 1
> > make[1]: *** [drivers/input/serio] Error 2
> > make: *** [drivers] Error 2
> 
> Please see this thread for patches:
>   http://lkml.org/lkml/2008/5/29/299

Thanks.  I applied the second patch in that thread, and it gets past
the serio.o module.

I realize this is not related to serio anymore, but now it stops here,
using the same config as in my previous email.  This is just a general
build report... I don't expect you to fix it personally. :-)

I can't seem to find ieee80211_tx_control anywhere in the tree, except in
pio.h.


  CC      drivers/net/wireless/airo.o
  CC      drivers/net/wireless/b43legacy/main.o
In file included from drivers/net/wireless/b43legacy/main.c:51:
drivers/net/wireless/b43legacy/pio.h:134: warning: 'struct ieee80211_tx_control' declared inside parameter list
drivers/net/wireless/b43legacy/pio.h:134: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/net/wireless/b43legacy/main.c: In function 'b43legacy_op_tx':
drivers/net/wireless/b43legacy/main.c:2375: error: too few arguments to function 'b43legacy_pio_tx'
make[4]: *** [drivers/net/wireless/b43legacy/main.o] Error 1
make[3]: *** [drivers/net/wireless/b43legacy] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

- Chris

