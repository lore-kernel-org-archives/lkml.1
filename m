Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbXD3O7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbXD3O7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbXD3O7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:59:34 -0400
Received: from ppsw-4.csi.cam.ac.uk ([131.111.8.134]:50085 "EHLO
	ppsw-4.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbXD3O7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:59:32 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <524f69650704300726l38c855fds49b00b9bd98360ac@mail.gmail.com>
References: <524f69650704300726l38c855fds49b00b9bd98360ac@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <FF9E865E-BD98-477F-A48D-1E501F516FB2@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: UID/GID override on CIFS mounts to Samba and proposed new mount parameter to disable Unix Extensions on the client
Date: Mon, 30 Apr 2007 15:59:02 +0100
To: Steve French <smfrench@gmail.com>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 Apr 2007, at 15:26, Steve French wrote:
> When CIFS Unix Extensions are negotiated we get the Unix uid and gid
> owners of the file from the server (on the Unix Query Path Info
> levels), but if the server's uids don't match the client uid's users
> were having to disable the Unix Extensions (which turned off features
> they still wanted).   The attached patch allows users to override uid
> and/or gid for file/directory owner with a default uid and/or gid
> specified at mount (as is often done when mounting from Linux cifs
> client to Windows server).  The attached patch also displays the uid
> and gid used by default in /proc/mounts (if applicable).
>
> I also would like suggestions on what we should call a proposed mount
> option (not coded yet) which would disable the CIFS Unix Extensions on
> a per-mount basis (or more likely actually would require it on the
> first mount to the server, subsequent mounts would probably inherit
> the capabilities).  Current cifs code can disable mount options before
> a mount by specifying
>
>     "echo 0 > /proc/fs/cifs/LinuxExtensionsEnabled")
>
> but it might be easier to specify it on mount (e.g.
> "nolinuxextensions" or "linuxextensions=no" ?).    Slightly harder
> would be disabling Unix Extensions after the user has already mounted
> (with Unix Extensions) to the same server (perhaps to a different
> share).  How important would it be to have two mounts to the same
> server one with unix extensions and one without?

Why "linuxextensions"?  I thought those are the "UNIX extensions"  
that Samba provides no matter on which platform it is run such as  
Linux, Mac OS X, Solaris, etc...

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


