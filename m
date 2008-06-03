Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbYFCLN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbYFCLN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 07:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYFCLNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 07:13:20 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47391 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbYFCLNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 07:13:19 -0400
To: mtk.manpages@googlemail.com
CC: miklos@szeredi.hu, drepper@redhat.com, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <cfd18e0f0806030405u1c32b114pa0fdd979f36f87fb@mail.gmail.com>
	(mtk.manpages@googlemail.com)
Subject: Re: [PATCH] utimensat() non-conformances and fixes [v3]
References: <482D4665.4050401@gmail.com>
	 <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <48401E7E.9090304@gmail.com> <cfd18e0f0806030405u1c32b114pa0fdd979f36f87fb@mail.gmail.com>
Message-Id: <E1K3URo-0005sj-JW@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 03 Jun 2008 13:13:00 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm not sure of the correct way to get the required nameidata (to do a
> > vfs_permission() call) from the file descriptor.  Can you give me a
> > tip there?
> 
> Could you point me at the right way of doing this?

You don't need nameidata for this at all.  Just call permission() with
a NULL nameidata.

Ugly API?  Yes, will be cleaned up if we manage to find some common
ground with the VFS maintainers.

Miklos
