Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYHWDLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYHWDLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 23:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYHWDLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 23:11:08 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:46503 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbYHWDLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 23:11:07 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Bart Trojanowski <bart@jukie.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] document additional vfat mount options
References: <20080820022712.GF28029@jukie.net>
	<1219452859-24960-1-git-send-email-bart@jukie.net>
Date: Sat, 23 Aug 2008 12:10:59 +0900
In-Reply-To: <1219452859-24960-1-git-send-email-bart@jukie.net> (Bart
	Trojanowski's message of "Fri, 22 Aug 2008 20:54:19 -0400")
Message-ID: <87k5e8ify4.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Trojanowski <bart@jukie.net> writes:

Thanks. However, some parts seem not true. I'll change those to the following.

> +nocase        -- If set, files and directories read from device will have
> +                 their names converted to lowercase.  Not set by
> +                 default.

nocase           -- This was deprecated for vfat. Use shortname=win95 instead.

> +showexec      -- If set, files that end if .EXE, .COM, or .BAT will have
> +                 the execute permission bits set.  Not set by default,
> +                 in which case all files show up with the execute bits set.

showexec         -- If set, the execute permission bits of the file will be
		    allowed only if the extension part of the name is .EXE,
                    .COM, or .BAT. Not set by default.

> +sys_immutable -- If set, all files on this filesystem which have the SYS
> +                 attribute (DOS bit) set will become IMMUTABLE (inode flag)
> +                 preventing write operations on these files.  Not set by
> +                 default.

sys_immutable    -- If set, ATTR_SYS attribute on FAT is handled as
		    IMMUTABLE flag on Linux. Not set by default.

> +flush         -- If set, modified inodes will be flushed to disk on file
> +                 close system call.  This is ideal for USB connected
> +                 devices.  Not set by default.

flush            -- If set, the filesystem will try to flush to disk more
		    early than normal. Not set by default.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
