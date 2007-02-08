Return-Path: <linux-kernel-owner+w=401wt.eu-S1423321AbXBHUjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423321AbXBHUjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 15:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423325AbXBHUjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 15:39:15 -0500
Received: from mail.fieldses.org ([66.93.2.214]:42686 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423321AbXBHUjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 15:39:15 -0500
X-Greylist: delayed 1614 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Feb 2007 15:39:14 EST
Date: Thu, 8 Feb 2007 15:12:19 -0500
To: Menny Hamburger <menny@exanet.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Getting the nfs_fh of a specific file/dir from the kernel
Message-ID: <20070208201219.GB22631@fieldses.org>
References: <A6FDE6B975803043804A49F12F49028E0F573A@hawk.exanet-il.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6FDE6B975803043804A49F12F49028E0F573A@hawk.exanet-il.co.il>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 06:38:48PM +0200, Menny Hamburger wrote:
> I have a piece of code in my 2.6 kernel that associates an ioctl
> file_operation to nfs in file.c and dir.c.
> This ioctl sends the nfs_fh to a userland application.

Doesn't /proc/fs/nfsd/filehandle do what you want already?

See nfs-util/utils/mountd/cache.c:cache_get_filehandle(), or, for the
kernel side, linux/fs/nfsd/nfsctl.c:write_filehandle().

(Just out of curiosity--why are you doing this?)

--b.
