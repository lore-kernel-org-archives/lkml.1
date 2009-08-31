Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbZHaHCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbZHaHCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 03:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbZHaHCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 03:02:51 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:51360 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166AbZHaHCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 03:02:51 -0400
Message-ID: <4A9B759B.7020401@msgid.tls.msk.ru>
Date: Mon, 31 Aug 2009 11:02:51 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: xfs compat_ioctl?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I tried to resize an xfs filesystem on 64bit 2.6.30 kernel
using 32bit userland, and that does not work, in dmesg I see:

ioctl32(xfs_growfs:24426): Unknown cmd fd(3) cmd(400c586e){t:'X';sz:12} arg(ffa56df4) on /mnt
ioctl32(xfs_growfs:24427): Unknown cmd fd(3) cmd(400c586e){t:'X';sz:12} arg(ff991254) on /mnt

so apparently there's no compat_ioctl layer for these ioctls.

Are there any plans to add these? :)

Thanks!

/mjt
