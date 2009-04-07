Return-Path: <linux-kernel-owner+w=401wt.eu-S1761132AbZDGXZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761132AbZDGXZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZDGXZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:25:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59439 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbZDGXZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:25:48 -0400
Message-ID: <49DBE0F9.7000207@garzik.org>
Date: Tue, 07 Apr 2009 19:25:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Oleg Drokin <green@linuxhacker.ru>
CC: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] VFS "stat light" out of fstatat, and fine grained
 flags
References: <20090407231524.GA1569655@fiona.linuxhacker.ru>
In-Reply-To: <20090407231524.GA1569655@fiona.linuxhacker.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Drokin wrote:
> Hello!
> 
>    This is reworked Mark Fasheh's patch + my earlier patch.
>    It allows one to specify which specific struct stat fields are needed
>    out of the fstatat call, and also a request to obtain most uptodate
>    information for inode (for NFS mostly).
> 
>    Also it adds AT_STAT_SELF flag to mean that the stat should be executed not
>    on a path, but on the passed filedecriptor itself.
> 
>    A first real kernel user for this added in loop block driver that does
>    not care about size or anything else besides rdev and inode number.
> 
>    I see various architectures replicate bits of vfs_*stat* in some compat
>    code, I am not sure if we need to update those as well or not.
> 
>    This patch does away with all the extra syscalls.


linux-kernel should be included in the discussion of this syscall.

	Jeff


