Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYESCX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYESCX3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 22:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbYESCXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 22:23:18 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:52819 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbYESCXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 22:23:17 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH 4/67] aufs configuration 
To: Jan Engelhardt <jengelh@medozas.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.1.10.0805161720530.15590@fbirervta.pbzchgretzou.qr>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <alpine.LNX.1.10.0805161720530.15590@fbirervta.pbzchgretzou.qr>
Date: Mon, 19 May 2008 11:23:10 +0900
Message-ID: <8238.1211163790@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
Thank you for your review and comments.

I will fix as you pointed out.

Jan Engelhardt:
> >+config AUFS_ROBR
> >+	bool "Aufs as an readonly branch of another aufs"
> >+	depends on AUFS
> >+	default n
> >+	help
> >+	If you want make your aufs to be a part of another aufs, then
> >+	enable this option. In other words, you can specify your aufs
> >+	path in 'br:' mount option for another aufs, but cannot
> >+	specify 'rw' as the branch permission.
> >+	It will damage the performance.
> >+	See detail in aufs.5.
> 
> IIRC, unionfs did not need such an option, so why does AUFS?

The *current* unionfs doesn't support such nested mount, ie. unionfs as
a branch of another unionfs mount.
Aufs supports it only readonly mode (if you enable this configuration).


> Performance is not "damaged" but "hurt"  :-) [or just "will negatively
> impact performance"]

English language is much more difficult than C language for me...


Junjiro Okajima
