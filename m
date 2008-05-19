Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbYESC1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbYESC1y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 22:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbYESC1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 22:27:45 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:52930 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbYESC1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 22:27:45 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH 5/67] aufs Makefile 
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080516172549.GA1915@uranus.ravnborg.org>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <20080516172549.GA1915@uranus.ravnborg.org>
Date: Mon, 19 May 2008 11:27:35 +0900
Message-ID: <8279.1211164055@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Sam,
Thank you for your review and comments.

I will fix as you pointed out.

Sam Ravnborg:
> Use:
> ccflags-$(CONFIG_AUFS_WORKAROUND_FUSE) += -DFUSE_SUPER_MAGIC=0x65735546

I didn't know that. It is much better.


> > +# dirty
> > +ifndef CONFIG_AUFS_HINOTIFY
> > +aufs-$(CONFIG_AUFS_DLGT) += hin_or_dlgt.o
> > +endif
> Can we have this dependency expressed in your Kconfig file?

I will add a new automatic configuration CONFIG_AUFS_HIN_OR_DLGT.


Junjiro Okajima
