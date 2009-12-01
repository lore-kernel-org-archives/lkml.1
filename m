Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbZLAE54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbZLAE54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 23:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZLAE5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 23:57:55 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:39204 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbZLAE5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 23:57:55 -0500
Date: Mon, 30 Nov 2009 23:57:27 -0500
Message-Id: <200912010457.nB14vRim030930@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jan Blunck <jblunck@infradead.org>
Subject: Re: [PATCH 41/41] union-mount: Add support for rename by __union_copyup() 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:39 PDT."
             <1256152779-10054-42-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-42-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Jan Blunck <jblunck@infradead.org>
> 
> It is possible to use __union_copyup() to support rename of regular files
> without returning -EXDEV.
> 
> XXX - Rewrite as copyup to old name followed by rename() + whiteout()

All this code just to support rename by copyup?!  I can see why we're
looking for other tricks, such as symlinks...

> Signed-off-by: Jan Blunck <jblunck@infradead.org>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>

> +//	error = hash_lookup_union(&oldnd, &oldnd.last, &old);
> +	error = lookup_rename_source(&oldnd, &newnd, &trap, &oldnd.last, &old);

> +//	if (is_unionized(newnd.path.dentry, newnd.path.mnt))
> +//		goto exit5;

Nuke.

Erez.
