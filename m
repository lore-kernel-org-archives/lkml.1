Return-Path: <linux-kernel-owner+w=401wt.eu-S1763201AbXG0QRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763201AbXG0QRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 12:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762922AbXG0QQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 12:16:55 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:34233 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762794AbXG0QQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 12:16:54 -0400
To: smfrench@gmail.com
CC: miklos@szeredi.hu, raven@themaw.net, linux-fsdevel@vger.kernel.org,
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
In-reply-to: <524f69650707270904j24038282le55f3981dff560a@mail.gmail.com>
	(smfrench@gmail.com)
Subject: Re: request for patches: showing mount options
References: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu>
	 <1185550256.3203.77.camel@raven.themaw.net>
	 <E1IERvH-00016M-00@dorka.pomaz.szeredi.hu> <524f69650707270904j24038282le55f3981dff560a@mail.gmail.com>
Message-Id: <E1IESNi-0001B9-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 27 Jul 2007 18:09:34 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> cifs and nfs (probably others) have some mount options which are mount
> order dependent ie may be invalid or ignored when you have more than
> one mount to the same server, or mount the same resource in two places
> with different options.  In the long run, at least for cifs, we may be
> able to better handle a user mounting to the same server twice with
> e.g. different security options (authentication, packet signing ...),
> but in the meantime are there any thoughts on whether those type of
> mount options should be displayed differently

I think they should be displayed normally, just as all the other
options.  If an option is shared by multiple mounts, that option
should be displayed for all of them.

This is similar to the case of per-mount vs. per-superblock options,
which aren't separated either.

Miklos
