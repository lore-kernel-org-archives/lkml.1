Return-Path: <linux-kernel-owner+w=401wt.eu-S1759182AbYC0Om6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182AbYC0Om6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 10:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756472AbYC0Omt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 10:42:49 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36964 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbYC0Oms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 10:42:48 -0400
To: 7eggert@gmx.de
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <E1JesoN-0000ta-Mo@be1.7eggert.dyndns.org> (message from Bodo
	Eggert on Thu, 27 Mar 2008 15:10:35 +0100)
Subject: Re: [patch 0/7] vfs: mountinfo (v4)
References: <abZpb-4D2-3@gated-at.bofh.it> <E1JesoN-0000ta-Mo@be1.7eggert.dyndns.org>
Message-Id: <E1JetJJ-0007h2-HQ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 27 Mar 2008 15:42:33 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Another update that fixes Al's latest comments:
> > 
> >  - the per-sb options are merged into the fs-specific options
> >  - mount source is shown as a separate field (because commas are not
> >    escaped within it)
> >  - group id checking before allocation/freeing: this one doesn't
> >    actually make a difference for the moment (I hope) but Al's variant
> >    is cleaner
> >  - simplify ID allocation and freeing
> >  - dominator renaming
> >  - function header comment updating
> 
> Is it robust against mounting /dev/$'abc def\x0dghi'
> to ~/mnt/`perl -e 'print "a" x 4050'`?

It is.

> Besides that, I don't like having 'none' as the mount source. Instead, I
> like to e.g. mount proc /proc -t proc, this will put the important
> information into the first column of the mount(1) output, right where I
> start reading.

So do that, this patch doesn't force you to put 'none' in there.

Miklos
