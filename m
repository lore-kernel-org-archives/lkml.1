Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbYE3Jxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbYE3Jxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 05:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbYE3Jxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 05:53:42 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52129 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbYE3Jxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 05:53:41 -0400
To: hch@infradead.org
CC: bfields@fieldses.org, miklos@szeredi.hu, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, neilb@suse.de
In-reply-to: <E1K20aX-0001NV-Vu@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Fri, 30 May 2008 11:07:53 +0200)
Subject: Re: [patch 4/8] nfsd: rename MAY_ flags
References: <20080529113245.450308367@szeredi.hu> <20080529113312.288347247@szeredi.hu> <20080529124701.GA13147@infradead.org> <E1K1iiF-00086t-Ve@pomaz-ex.szeredi.hu> <20080529204002.GC24018@fieldses.org> <20080530073607.GB7758@infradead.org> <E1K20aX-0001NV-Vu@pomaz-ex.szeredi.hu>
Message-Id: <E1K21If-0001Sa-Ex@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 30 May 2008 11:53:29 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> These three constants are very much ingrained in the UNIX tradition,
> and it's no accident that the MAY_ flags correspond exactly to the
> i_mode bits, which is something often exploited by permission checking
> code.

Funny example of naming confusion:

> asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
> {
> 	...
> 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
> 		return -EINVAL;

The MAY_* namespace is never mentioned, even though that's the one
most relevant here :)

Miklos
