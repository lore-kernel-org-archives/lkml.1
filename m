Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbZDQT0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbZDQT0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbZDQT0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:26:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:51253 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544AbZDQT0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:26:36 -0400
Message-ID: <49E8D7DD.7080907@suse.com>
Date: Fri, 17 Apr 2009 15:26:21 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.30-rc2: reiserfs_delete_xattrs: Couldn't delete all xattrs
 (-13)
References: <a4423d670904161223r2e026b6u903137c709318551@mail.gmail.com>
In-Reply-To: <a4423d670904161223r2e026b6u903137c709318551@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Alexander Beregalov wrote:
> Hi Jeff
> 
> The kernel prints this message every 20seconds
> [  836.973100]
> [  836.983494] REISERFS warning (device sda2): jdm-20004
> reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
> [  836.983496]
> [  894.203634] REISERFS warning (device sda2): jdm-20004
> reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
> [  894.203636]
> [  894.205784] REISERFS warning (device sda2): jdm-20004
> reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
> 
> commit a41f1a4715
> 
> CONFIG_REISERFS_FS=y
> # CONFIG_REISERFS_CHECK is not set
> # CONFIG_REISERFS_PROC_INFO is not set
> # CONFIG_REISERFS_FS_XATTR is not set
> 
> I did not enable XATTR before,
> should I enable it now ?

Thanks for the report. I'm taking a look at it now.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkno19wACgkQLPWxlyuTD7L9dQCeODUthInHguXbxmpmjKf2KpZB
3BAAmwTFgx4u/YlIoftrWy+x9nd8DrDO
=rdNj
-----END PGP SIGNATURE-----
