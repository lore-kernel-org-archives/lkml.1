Return-Path: <linux-kernel-owner+w=401wt.eu-S935370AbXG0O1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935370AbXG0O1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 10:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932184AbXG0O06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 10:26:58 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:34211 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760259AbXG0O05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 10:26:57 -0400
To: smfrench@gmail.com
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kzak@redhat.com, ericvh@gmail.com, lucho@ionkov.net,
       zippel@linux-m68k.org, hpa@zytor.com, raven@themaw.net,
       rathamahata@php4.ru, dhowells@redhat.com, sfrench@samba.org,
       mhalcrow@us.ibm.com, phillip@hellewell.homeip.net,
       hirofumi@mail.parknet.co.jp, mikulas@artax.karlin.mff.cuni.cz,
       wli@holomorphy.com, shaggy@austin.ibm.com, vandrove@vc.cvut.cz,
       trond.myklebust@fys.uio.no, aia21@cantab.net, mark.fasheh@oracle.com,
       kurt.hackel@oracle.com, reiserfs-devel@vger.kernel.org,
       bfennema@falcon.csc.calpoly.edu, dushistov@mail.ru,
       xfs-masters@oss.sgi.com, arnd@arndb.de, holzheu@de.ibm.com
In-reply-to: <524f69650707270710u7c21aea0v5d997484f33b3434@mail.gmail.com>
	(smfrench@gmail.com)
Subject: Re: request for patches: showing mount options
References: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu> <524f69650707270710u7c21aea0v5d997484f33b3434@mail.gmail.com>
Message-Id: <E1IEQg8-0000ut-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 27 Jul 2007 16:20:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What do you consider the best example so far of a kernel module's
> equivalent of "parse_mount_options" (handling a mix of options of
> different types) and show_options.

For example gfs2 is pretty good.  It has lots of different type of
options, and it handles them in remount as well as mount.

Miklos
