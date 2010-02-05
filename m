Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab0BEIOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 03:14:20 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50421 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab0BEIOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 03:14:18 -0500
To: 7eggert@gmx.de
CC: miklos@szeredi.hu, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, eugene@redhat.com, mtk.manpages@gmail.com
In-reply-to: <E1Nd6kb-000458-Ne@be1.7eggert.dyndns.org> (message from Bodo
	Eggert on Thu, 04 Feb 2010 19:48:25 +0100)
Subject: Re: [RFC PATCH] vfs: add MNT_NOFOLLOW flag to umount(2)
References: <eae9I-mz-1@gated-at.bofh.it> <E1Nd6kb-000458-Ne@be1.7eggert.dyndns.org>
Message-Id: <E1NdJKL-0003K8-S1@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 05 Feb 2010 09:14:09 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Feb 2010, Bodo Eggert wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > Additionally, return -EINVAL if an unknown flag is encountered.  This
> > makes it possible for the caller to determine if a flag is supported
> > or not (at least on kernels with this patch).
> 
> There should be a guaranteed-to-be-invalid flag or flag-combination in
> order to safely detect this feature.

It's difficult though, because the app would have to make sure the
detection itself would reliably fail, and with a different error.

Simply checking the kernel version might be easier.

Thanks,
Miklos
