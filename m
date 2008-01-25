Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbYAYKDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbYAYKDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYAYKDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:03:05 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45280 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbYAYKDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:03:03 -0500
To: ezk@cs.sunysb.edu
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       sfrench@us.ibm.com, lachlan@sgi.com, jsipek@cs.sunysb.edu,
       rmk@arm.linux.org.uk, zippel@linux-m68k.org, dhowells@redhat.com,
       raven@themaw.net, rathamahata@php4.ru, kkeil@suse.de, hpa@zytor.com,
       tytso@mit.edu, hirofumi@mail.parknet.co.jp, jdike@addtoit.com,
       mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com,
       shaggy@austin.ibm.com, vandrove@vc.cvut.cz, Trond.Myklebust@netapp.com,
       jeffm@suse.com, paulus@samba.org, hugh@veritas.com, gorcunov@gmail.com,
       gregkh@suse.de
In-reply-to: <200801250024.m0P0OmXX011168@agora.fsl.cs.sunysb.edu> (message
	from Erez Zadok on Thu, 24 Jan 2008 19:24:48 -0500)
Subject: Re: [patch 01/26] mount options: add documentation
References: <200801250024.m0P0OmXX011168@agora.fsl.cs.sunysb.edu>
Message-Id: <E1JILOa-0001Ru-MN@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 25 Jan 2008 11:02:48 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Where did you check for the existence of a ->show_options method for
> unionfs?  Unionfs does implement ->show_options and supports all of the
> mount/remount options.  See:
> 
> <http://git.kernel.org/?p=linux/kernel/git/ezk/unionfs.git;a=blob;f=fs/unionfs/super.c;h=986c980261a5b171147d66ac05bf08423e2fd6b6;hb=HEAD#l963>
> 
> The unionfs ->remount code supports branch-management options which can
> add/del/change a branch, but we don't show those directly in ->show_options;
> it makes more sense to show the final (and thus most current) branch
> configuration.
> 
> Could you update your records please?

Sure.  Sorry about that, I did actually look at unionfs, and it was
just an administration error and bad memory (in my head).

> BTW, I should be able to use your save_mount_options().

It is probably better not to use save_mount_options().  Especially,
since unionfs implemets a remount, that changes the tree only
partially AFAICS.

Miklos
