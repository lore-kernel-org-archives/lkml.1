Return-Path: <linux-kernel-owner+w=401wt.eu-S1031624AbXEAJbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031624AbXEAJbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031627AbXEAJbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:31:21 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:38894 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031624AbXEAJbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:31:19 -0400
Date: Tue, 1 May 2007 11:30:31 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Steve French <smfrench@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
Subject: Re: SMB2 file system - should it be a distinct module
In-Reply-To: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0705011127130.18504@yvahk01.tjqt.qr>
References: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 30 2007 17:52, Steve French wrote:
>
> Now that we (Samba team) understand enough about it to implement
> prototypes (there is a prototype server in Samba 4, and a userspace
> client library for testing), we need to decide whether the kernel
> implementation of SMB2 client should be a distinct module or just part
> of the cifs.ko module.

Do it like CONFIG_FAT_FS/CONFIG_MSDOS_FS/CONFIG_VFAT_FS...

config SMB_COMMON
    tristate

config CIFS
    select SMB_COMMON

config SMB2
    select SMB_COMMON

> SMB2 (the protocol) is smaller than cifs,

Could not they have named it CIFS2... :p

And, what also puzzles me... almost every filesystem that's not at revision 1
anymore (ext2/3/4, reiser4, smb2) does not have the usually omnipresent "fs"
suffix anymore (cf. reiserfs, smbfs). Maybe it's time to drop all the "fs"
suffixes? :)


Jan
-- 
