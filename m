Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbYL0Sme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbYL0Sme (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 13:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbYL0SmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 13:42:25 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:45899 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbYL0SmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 13:42:24 -0500
Date: Sat, 27 Dec 2008 19:43:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headers_check.pl: disallow extern's
Message-ID: <20081227184355.GA9264@uranus.ravnborg.org>
References: <1230363816-24097-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230363816-24097-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 02:43:36AM -0500, Mike Frysinger wrote:
> Since prototypes with "extern" refer to kernel functions, they make no
> sense in userspace, so reject them automatically.

Hi Mike.

I do agree with this - but adding this check resulted in:
usr/include/linux/coda_psdev.h:90: extern's make no sense in userspace
usr/include/linux/elf-fdpic.h:62: extern's make no sense in userspace
usr/include/linux/elf.h:379: extern's make no sense in userspace
usr/include/linux/elf.h:387: extern's make no sense in userspace
usr/include/linux/elf.h:401: extern's make no sense in userspace
usr/include/linux/elf.h:402: extern's make no sense in userspace
usr/include/linux/fs.h:24: extern's make no sense in userspace
usr/include/linux/fs.h:41: extern's make no sense in userspace
usr/include/linux/fs.h:42: extern's make no sense in userspace
usr/include/linux/fs.h:49: extern's make no sense in userspace
usr/include/linux/fs.h:51: extern's make no sense in userspace
usr/include/linux/fs.h:54: extern's make no sense in userspace
usr/include/linux/hid.h:74: extern's make no sense in userspace
usr/include/linux/in6.h:47: extern's make no sense in userspace
usr/include/linux/in6.h:49: extern's make no sense in userspace
usr/include/linux/nubus.h:296: extern's make no sense in userspace
usr/include/linux/nubus.h:298: extern's make no sense in userspace
usr/include/linux/nubus.h:302: extern's make no sense in userspace
usr/include/linux/reiserfs_fs.h:687: extern's make no sense in userspace
usr/include/linux/reiserfs_fs.h:995: extern's make no sense in userspace
usr/include/linux/reiserfs_fs.h:997: extern's make no sense in userspace
usr/include/linux/reiserfs_fs.h:1467: extern's make no sense in userspace
usr/include/linux/reiserfs_fs.h:1760: extern's make no sense in userspace
usr/include/linux/reiserfs_fs.h:1764: extern's make no sense in userspace
usr/include/linux/reiserfs_fs.h:1766: extern's make no sense in userspace
usr/include/linux/reiserfs_fs.h:1769: extern's make no sense in userspace
usr/include/linux/reiserfs_fs.h:1771: extern's make no sense in userspace
usr/include/linux/reiserfs_fs.h:1805: extern's make no sense in userspace
usr/include/linux/reiserfs_fs.h:1948: extern's make no sense in userspace
usr/include/linux/reiserfs_fs.h:1949: extern's make no sense in userspace
usr/include/linux/reiserfs_fs.h:1950: extern's make no sense in userspace
usr/include/linux/reiserfs_fs.h:1951: extern's make no sense in userspace
usr/include/linux/reiserfs_fs.h:1962: extern's make no sense in userspace
usr/include/linux/reiserfs_fs.h:1963: extern's make no sense in userspace
usr/include/linux/reiserfs_fs.h:1964: extern's make no sense in userspace
usr/include/linux/socket.h:29: extern's make no sense in userspace
usr/include/linux/sound.h:33: extern's make no sense in userspace
usr/include/linux/sound.h:34: extern's make no sense in userspace
usr/include/linux/sound.h:35: extern's make no sense in userspace
usr/include/linux/sound.h:36: extern's make no sense in userspace
usr/include/linux/sound.h:37: extern's make no sense in userspace
usr/include/linux/sound.h:39: extern's make no sense in userspace
usr/include/linux/sound.h:40: extern's make no sense in userspace
usr/include/linux/sound.h:41: extern's make no sense in userspace
usr/include/linux/sound.h:42: extern's make no sense in userspace
usr/include/linux/soundcard.h:1047: extern's make no sense in userspace
usr/include/linux/soundcard.h:1048: extern's make no sense in userspace
usr/include/linux/soundcard.h:1049: extern's make no sense in userspace
usr/include/linux/soundcard.h:1050: extern's make no sense in userspace
usr/include/linux/soundcard.h:1051: extern's make no sense in userspace
usr/include/linux/soundcard.h:1053: extern's make no sense in userspace
usr/include/linux/soundcard.h:1055: extern's make no sense in userspace
usr/include/linux/soundcard.h:1056: extern's make no sense in userspace
usr/include/linux/soundcard.h:1061: extern's make no sense in userspace
usr/include/linux/soundcard.h:1062: extern's make no sense in userspace
usr/include/linux/soundcard.h:1078: extern's make no sense in userspace
usr/include/linux/soundcard.h:1079: extern's make no sense in userspace


And we need to get these fixed before we apply this patch.
Otherwise we will break every allyesconfig/allmodconfig builds

	Sam
