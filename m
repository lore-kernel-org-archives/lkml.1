Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab0BQVgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 16:36:36 -0500
Received: from mail.gmx.net ([213.165.64.20]:56492 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753844Ab0BQVge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 16:36:34 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/iGhgQNtHiZjR6EMmzHDXvmozDlg/v5qPx9kJCJN
	MW1MXlqvVu34PL
Date: Wed, 17 Feb 2010 22:35:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Media Mailing List <linux-media@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] V4L/DVB: v4l: document new Bayer and monochrome
 pixel formats
In-Reply-To: <4B7C5D60.3010208@redhat.com>
Message-ID: <Pine.LNX.4.64.1002172234330.4623@axis700.grange>
References: <4B7C239D.6010609@redhat.com> <Pine.LNX.4.64.1002172153020.4623@axis700.grange>
 <4B7C5D60.3010208@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010, Mauro Carvalho Chehab wrote:

> Guennadi,
> 
> Your original patch were against the out-of-tree "media-specs/Makefile", present
> only at the -hg tree. 
> 
> The way my conversion scripts work is that they'll convert the patches into a
> patch that can be applied directly into -git. Among other things, all
> changes on files outside the kernel tree are simply discarded by them.
>  
> Also, before patch 2/4, such addition won't be possible.
> 
> So, what happened here is that, after importing from your hg tree, I noticed 
> -git compilation breakage. So, I ported the autobuild bits for media-entities & co,
> manually added the missing pixfmt xml's and removed the duplicate symbol for one
> of the bayer standards.
> 
> That's said, I don't really have any preference about the order where the files appear
> at the Makefile. I have no objection if you prefer to add them on any other random order.
> 
> In a matter of fact, IMO, the better is to later write a patch that discards
> this static list of files, auto-generating it dynamically.
> 
> So, if you really prefer a different order, please re-submit another version for this patch.

No, no problem with me, it doesn't bother me _that_ much;) Thanks for 
fixing stuff!

Thanks
Guennadi
---
Guennadi Liakhovetski
