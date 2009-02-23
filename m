Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbZBWOXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbZBWOXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 09:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbZBWOX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 09:23:28 -0500
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:49418 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbZBWOX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 09:23:27 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC 2/8] Aufs2: structure 
To: Tomas M <tomas@slax.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <49A268A7.1010708@slax.org>
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl> <49A268A7.1010708@slax.org>
Date: Mon, 23 Feb 2009 23:23:23 +0900
Message-ID: <13899.1235399003@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tomas M:
> > The struct of a xino file is simple, just a sequence of aufs inode
> > numbers which is indexed by the lower inode number.
> > In the above sample, assume the inode number of /ro/fileA is i111 and
> > aufs assigns the inode number i999 for fileA. Then aufs writes 999 as
> > 4(8) bytes at 111 * 4(8) bytes offset in the xino file.
> 
> I think it is worth mentioning that the xino file, if I understand it correctly, is a 'sparse file', that means it is full of 'holes' and doesn't consume as much disk space as it might appear.

That is right.
Thank you for pointing out.


> In my opinion, the current xino-file approach is not much usable on filesystems which do not support sparse files (for example, if you wish to union two vfats), since some 'seeks' would probably write a lot of nulls. But I am not any kernel developer so I don't even know if there exists any filesystem which would be unable to support sparse files (except the mentioned VFAT, of course).

Aufs creats the xino files on the first writable branch. If it consumes
disk space for holes, then an aufs mount option 'xino=<path>' may be
useful.

I will update my local documents.
Thank you.


J. R. Okajima
