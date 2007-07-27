Return-Path: <linux-kernel-owner+w=401wt.eu-S936685AbXG0UFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936685AbXG0UFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763714AbXG0UFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:05:22 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:32816 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763691AbXG0UFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:05:19 -0400
To: chuck.lever@oracle.com
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
In-reply-to: <46AA4AC5.2050200@oracle.com> (message from Chuck Lever on Fri,
	27 Jul 2007 15:43:01 -0400)
Subject: Re: request for patches: showing mount options
References: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu> <46AA4AC5.2050200@oracle.com>
Message-Id: <E1IEW21-0001kL-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 27 Jul 2007 22:03:25 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Some mount options are never passed to the kernel, and thus can't appear 
> in /proc/mounts.  Examples include user, users, and _netdev for NFS.

These options control *who* may mount and *when* to mount.  They are
not a property of the mount itself and are not added to /etc/mtab.

There's a "user=ID" option that is added to /etc/mtab in case of user
mounts.  This identifies the owner of the mount, so that it can be
unmounted by that user.  There are patches in -mm that enable the
kernel to store this info.

Do you have other examples in mind?

Miklos

