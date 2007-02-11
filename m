Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbXBKIGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbXBKIGH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 03:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbXBKIGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 03:06:07 -0500
Received: from mail.exanet.com ([212.143.73.109]:38693 "EHLO mr.exanet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbXBKIGG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 03:06:06 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: Getting the nfs_fh of a specific file/dir from the kernel
Date: Sun, 11 Feb 2007 10:06:02 +0200
Message-ID: <A6FDE6B975803043804A49F12F49028E0F573D@hawk.exanet-il.co.il>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Getting the nfs_fh of a specific file/dir from the kernel
Thread-Index: AcdNsv0JVcXnWcelSECJSvHVdOUEIQAAAxQw
From: "Menny Hamburger" <menny@exanet.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We implement our own nfsd in user space - so the  kernel nfsd (as well
as the lockd) are disabled.
We need the handle in order to associate a kernel file handle with our
own file id.

M.

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of J. Bruce Fields
Sent: Thursday, February 08, 2007 10:12 PM
To: Menny Hamburger
Cc: linux-kernel@vger.kernel.org
Subject: Re: Getting the nfs_fh of a specific file/dir from the kernel

On Thu, Feb 08, 2007 at 06:38:48PM +0200, Menny Hamburger wrote:
> I have a piece of code in my 2.6 kernel that associates an ioctl 
> file_operation to nfs in file.c and dir.c.
> This ioctl sends the nfs_fh to a userland application.

Doesn't /proc/fs/nfsd/filehandle do what you want already?

See nfs-util/utils/mountd/cache.c:cache_get_filehandle(), or, for the
kernel side, linux/fs/nfsd/nfsctl.c:write_filehandle().

(Just out of curiosity--why are you doing this?)

--b.
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel"
in the body of a message to majordomo@vger.kernel.org More majordomo
info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


