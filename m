Return-Path: <linux-kernel-owner+w=401wt.eu-S936660AbXG0Pne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936660AbXG0Pne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 11:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932245AbXG0PnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 11:43:24 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:49329 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761723AbXG0PnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 11:43:23 -0400
To: raven@themaw.net
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kzak@redhat.com, ericvh@gmail.com, lucho@ionkov.net,
       zippel@linux-m68k.org, hpa@zytor.com, rathamahata@php4.ru,
       dhowells@redhat.com, sfrench@samba.org, mhalcrow@us.ibm.com,
       phillip@hellewell.homeip.net, hirofumi@mail.parknet.co.jp,
       mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com,
       shaggy@austin.ibm.com, vandrove@vc.cvut.cz, trond.myklebust@fys.uio.no,
       aia21@cantab.net, mark.fasheh@oracle.com, kurt.hackel@oracle.com,
       reiserfs-devel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu,
       dushistov@mail.ru, xfs-masters@oss.sgi.com, arnd@arndb.de,
       holzheu@de.ibm.com
In-reply-to: <1185550256.3203.77.camel@raven.themaw.net> (message from Ian
	Kent on Fri, 27 Jul 2007 23:30:56 +0800)
Subject: Re: request for patches: showing mount options
References: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu> <1185550256.3203.77.camel@raven.themaw.net>
Message-Id: <E1IERvH-00016M-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 27 Jul 2007 17:40:11 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>   all - fs has options, but doesn't define ->show_options()
>   some - fs defines ->show_options(), but some options are not shown
>   noopt - fs does not have options
>   good - fs shows all options
>   patch - I have a patch

[...]

> > autofs      all
> 
> I'm not sure I understand this.
> How does autofs show it's options without a ->show_options method?

It doesn't.  The "all" means, all of them need to be added to
->show_options(), not that all are shown.

I can see now that this is slightly confusing, sorry.

So the ones that need attention are "all" and "some".  The others are
fine in theory.  Of course I may have missed something.

> > autofs4     some
> 
> OK, uid and gid aren't shown.
> That should be straight forward to fix.
> What's your time frame for this?

ASAP ;)

2.6.24 would be a nice, but it won't be easy...

Miklos
