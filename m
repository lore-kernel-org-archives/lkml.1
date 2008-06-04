Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbYFDE2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbYFDE2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbYFDE2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:28:25 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59254 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbYFDE2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:28:25 -0400
To: mtk.manpages@googlemail.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@lst.de,
       miklos@szeredi.hu, viro@zeniv.linux.org.uk, jamie@shareable.org,
       drepper@redhat.com, linux-fsdevel@vger.kernel.org,
       subrata@linux.vnet.ibm.com
In-reply-to: <4845C4B4.8040706@gmail.com> (message from Michael Kerrisk on
	Wed, 04 Jun 2008 00:24:52 +0200)
Subject: Re: [parch 1/4] vfs: utimensat(): ignore tv_sec if tv_nsec == UTIME_OMIT
 or UTIME_NOW
References: <4845C4B4.8040706@gmail.com>
Message-Id: <E1K3kbK-0007c4-PF@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Jun 2008 06:27:54 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The POSIX.1 draft spec for utimensat() says that if a times[n].tv_nsec
> field is UTIME_OMIT or UTIME_NOW, then the value in the corresponding
> tv_sec field is ignored.  However the current Linux implementation
> requires the tv_sec value to be zero (or the EINVAL error results).
> This requirement should be removed.
> 
> CC: Miklos Szeredi <miklos@szeredi.hu>
> CC: Al Viro <viro@zeniv.linux.org.uk>
> CC: Ulrich Drepper <drepper@redhat.com>
> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>

Would it be possible to quote the relevant parts of the draft?
Otherwise

Acked-by: Miklos Szeredi <mszeredi@suse.cz>
