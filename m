Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbZKCLcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbZKCLcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 06:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZKCLcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 06:32:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:61156 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZKCLcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 06:32:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] fs: add missing compat_ptr handling for FS_IOC_RESVSP ioctl
Date: Tue, 3 Nov 2009 12:32:12 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ankit Jain <me@ankitjain.org>, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       "David S. Miller" <davem@davemloft.net>
References: <20091103104532.GA19670@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20091103104532.GA19670@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911031232.12245.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+9eZ46yqjMtPluiBucaKi68b4d/Dat+21HHmu
 FyRz9VPd2h970lAW8sTSJReby8IOt+ehP8IWWh9OeAtP8hwaPx
 KCII8h8WAYIDIEUKpi/HQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 November 2009, Heiko Carstens wrote:
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> For FS_IOC_RESVSP and FS_IOC_RESVSP64 compat_sys_ioctl() uses its
> arg argument as a pointer to userspace. However it is missing a
> a call to compat_ptr() which will do a proper pointer conversion.
> 
> This was introduced with 3e63cbb1 "fs: Add new pre-allocation ioctls
> to vfs for compatibility with legacy xfs ioctls".
> 
> Cc: Ankit Jain <me@ankitjain.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Arnd Bergmann <arndbergmann@googlemail.com>
> Acked-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
