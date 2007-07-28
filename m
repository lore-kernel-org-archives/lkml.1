Return-Path: <linux-kernel-owner+w=401wt.eu-S938620AbXG1ClS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938620AbXG1ClS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 22:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761102AbXG1ClI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 22:41:08 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:24741 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759980AbXG1ClG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 22:41:06 -0400
Date: Fri, 27 Jul 2007 19:45:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Wyatt Banks <wyatt@banksresearch.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: document HFSPlus
Message-Id: <20070727194541.c37a0ba4.randy.dunlap@oracle.com>
In-Reply-To: <46AA9B1B.10206@banksresearch.com>
References: <46AA9B1B.10206@banksresearch.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 21:25:47 -0400 Wyatt Banks wrote:

> From:	Wyatt Banks <wyatt@banksresearch.com>
> 
> Documentation: document HFSPlus filesystem and its mount options.
> 
> Signed-off-by:	Wyatt Banks <wyatt@banksresearch.com>

Thanks.

> ---
> 
> Patched against 2.6.22.1

FYI:  Patches should be against the latest -rc or -git (when
available), but it probably doesn't matter in this case.


> diff -uprN linux-2.6.22.1/Documentation/filesystems/hfsplus.txt linux-2.6.22.1-devel/Documentation/filesystems/hfsplus.txt
> --- linux-2.6.22.1/Documentation/filesystems/hfsplus.txt	1969-12-31 19:00:00.000000000 -0500
> +++ linux-2.6.22.1-devel/Documentation/filesystems/hfsplus.txt	2007-07-27 21:11:10.000000000 -0400
> @@ -0,0 +1,59 @@
> +
> +Macintosh HFSPlus Filesystem for Linux
> +======================================
> +
> +HFSPlus is a filesystem first introduced in MacOS 8.1.
> +HFSPlus has several extensions to HFS, including 32 bit allocation

                                                    32-bit

> +blocks, 255 character unicode filenames, and file sizes of 2^63 bytes.

           255-character

> +
> +
> +Mount options
> +=============
> +
> +When mounting an HFSPlus filesystem, the following options are accepted:
> +
> +  creator=cccc, type=cccc
> +	Specifies the creator/type values as shown by the MacOS finder
> +	used for creating new files.  Default values: '????'.
> +
> +  uid=n, gid=n
> +	Specifies the user/group that owns all files on the filesystem
> +	that have uninitialized permissions structures.
> +	Default:  user/group id of the mounting process.
> +
> +  umask=n
> +	Specifies the umask used for files and directories that have
> +	uninitialized permissions structures.
> +	Default:  umask of the mounting process.

	in octal

> +  session=n
> +	Select the CDROM session to mount as HFSPlus filesystem.  Defaults to
> +	leaving that decision to the CDROM driver.  This option will fail
> +	with anything but a CDROM as underlying devices.
> +
> +  part=n
> +	Select partition number n from the devices.  Does only makes
> +	sense for CDROMS because they can't be partitioned under Linux.

                  CDROMs or CD-ROMs
	and this sentence is confusing to me.  Please check it.

> +	For disk devices the generic partition parsing code does this
> +	for us.  Defaults to not parsing the partition table at all.
> +
> +  decompose
> +	Decompose file name characters.
> +
> +  nodecompose
> +	Do not decompose file name characters.
> +
> +  force
> +	Used to force write access to volumes that are marked as journalled
> +	or locked.  Use at your own risk.
> +
> +  nls=cccc
> +	Encoding to use when presenting file names.
> +
> +
> +References
> +==========
> +
> +kernel source:		<file:fs/hfsplus>
> +
> +Apple Technote 1150	http://developer.apple.com/technotes/tn/tn1150.html


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
