Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbYFCMR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbYFCMR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 08:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757401AbYFCMRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 08:17:00 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50173 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369AbYFCMQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 08:16:58 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, mtk.manpages@googlemail.com, drepper@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20080603112221.GW28946@ZenIV.linux.org.uk> (message from Al Viro
	on Tue, 3 Jun 2008 12:22:21 +0100)
Subject: Re: [PATCH] utimensat() non-conformances and fixes [v3]
References: <482D4665.4050401@gmail.com> <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <48401E7E.9090304@gmail.com> <cfd18e0f0806030405u1c32b114pa0fdd979f36f87fb@mail.gmail.com> <E1K3URo-0005sj-JW@pomaz-ex.szeredi.hu> <20080603112221.GW28946@ZenIV.linux.org.uk>
Message-Id: <E1K3VRJ-00065P-Pq@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 03 Jun 2008 14:16:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > I'm not sure of the correct way to get the required nameidata (to do a
> > > > vfs_permission() call) from the file descriptor.  Can you give me a
> > > > tip there?
> > > 
> > > Could you point me at the right way of doing this?
> > 
> > You don't need nameidata for this at all.  Just call permission() with
> > a NULL nameidata.
> > 
> > Ugly API?  Yes, will be cleaned up if we manage to find some common
> > ground with the VFS maintainers.
> 
> As soon as I'm done with sysctls...

Can't you just do that independently (for now just put a
d_find_alias() in there and be done with it)?  If you fix every piece
of horrid code that you come across, it'll never be done...

Miklos
