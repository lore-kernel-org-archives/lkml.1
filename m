Return-Path: <linux-kernel-owner+w=401wt.eu-S936535AbXHHSwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936535AbXHHSwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbXHHSwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:52:11 -0400
Received: from smtp.nokia.com ([131.228.20.170]:25608 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbXHHSwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:52:10 -0400
Message-ID: <46BA1080.2060907@yandex.ru>
Date: Wed, 08 Aug 2007 21:50:40 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch 05/18] fs/logfs/dir.c
References: <20070808161234.GB15319@lazybastard.org> <20070808161626.GG15319@lazybastard.org>
In-Reply-To: <20070808161626.GG15319@lazybastard.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Aug 2007 18:50:41.0023 (UTC) FILETIME=[048DD8F0:01C7D9ED]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> + * Unlink and rmdir also share the same function: unlink.  Again, this
> + * function works in two atomic steps
> + * 1. remove dentry (remember inode in journal)
> + * 2. unlink inode (clear journal)

May you please elaborate a little what is journal in LogFS? Is it only for
one operation? Does it have fixed position on flash? How large is it?

Thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
