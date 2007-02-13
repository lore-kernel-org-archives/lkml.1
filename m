Return-Path: <linux-kernel-owner+w=401wt.eu-S1751410AbXBMXNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbXBMXNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 18:13:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbXBMXNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 18:13:13 -0500
Received: from pat.uio.no ([129.240.10.15]:41951 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbXBMXNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 18:13:13 -0500
Subject: RE: Getting the nfs_fh of a specific file/dir from the kernel
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Menny Hamburger <menny@exanet.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org
In-Reply-To: <A6FDE6B975803043804A49F12F49028E0F573D@hawk.exanet-il.co.il>
References: <A6FDE6B975803043804A49F12F49028E0F573D@hawk.exanet-il.co.il>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 15:13:01 -0800
Message-Id: <1171408381.6031.1.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: 997EDBDC1EE1B7AD1C1D8EA0E19D676BA71B5C6B
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 111 total 443224 max/h 2716 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-11 at 10:06 +0200, Menny Hamburger wrote:
> We implement our own nfsd in user space - so the  kernel nfsd (as well
> as the lockd) are disabled.
> We need the handle in order to associate a kernel file handle with our
> own file id.

Filehandles are not part of any API that is exported to userland. There
are many reasons why that would be a bad idea.

Cheers
  Trond

> M.
> 
> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of J. Bruce Fields
> Sent: Thursday, February 08, 2007 10:12 PM
> To: Menny Hamburger
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: Getting the nfs_fh of a specific file/dir from the kernel
> 
> On Thu, Feb 08, 2007 at 06:38:48PM +0200, Menny Hamburger wrote:
> > I have a piece of code in my 2.6 kernel that associates an ioctl 
> > file_operation to nfs in file.c and dir.c.
> > This ioctl sends the nfs_fh to a userland application.
> 
> Doesn't /proc/fs/nfsd/filehandle do what you want already?
> 
> See nfs-util/utils/mountd/cache.c:cache_get_filehandle(), or, for the
> kernel side, linux/fs/nfsd/nfsctl.c:write_filehandle().
> 
> (Just out of curiosity--why are you doing this?)
> 
> --b.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

