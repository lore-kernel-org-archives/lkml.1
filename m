Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYL0DDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYL0DDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 22:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYL0DDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 22:03:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64745 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbYL0DDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 22:03:32 -0500
Date: Sat, 27 Dec 2008 03:58:18 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@bogon.housecafe.de
To: Pavel Machek <pavel@suse.cz>
cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext3 defaults to errors=continue, why?
In-Reply-To: <20081226213039.GA23836@atrey.karlin.mff.cuni.cz>
Message-ID: <alpine.DEB.2.00.0812270341310.24239@bogon.housecafe.de>
References: <20081226213039.GA23836@atrey.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (DEB 1169 2008-08-27)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Provags-ID: V01U2FsdGVkX19DdByxwwvN+qpnm9hh1SmwtajGxKKT4GbiFT0
 by7lvuTHYv/OjT9YOf+eovwh+NmABeJ7ARzDXZJN4JXI3uyJfu
 01bRj4yJoXwY12Pi6L5cQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Dec 2008, Pavel Machek wrote:
> I don't know where errors=continue came from (and I think its
> dangerous);

In lib/ext2fs/ext2_fs.h (from e2fsprogs) a default is set:

#define EXT2_ERRORS_CONTINUE		1	/* Continue execution */
#define EXT2_ERRORS_RO			2	/* Remount fs read-only */
#define EXT2_ERRORS_PANIC		3	/* Panic */
#define EXT2_ERRORS_DEFAULT		EXT2_ERRORS_CONTINUE

...which is then referenced in lib/ext2fs/initialize.c - but I agree, I 
find this dangerous myself and the first thing I do after mkfs is always 
to tune2fs to remount-ro.

Christian.
-- 
BOFH excuse #39:

terrorist activities
