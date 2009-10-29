Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbZJ2Iiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbZJ2Iiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZJ2Iiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:38:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39629
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752229AbZJ2Iit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:38:49 -0400
Date: Thu, 29 Oct 2009 01:39:13 -0700 (PDT)
Message-Id: <20091029.013913.258759148.davem@davemloft.net>
To: heiko.carstens@de.ibm.com
Cc: arndbergmann@googlemail.com, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com, me@ankitjain.org,
       hch@lst.de, viro@zeniv.linux.org.uk
Subject: Re: is avoiding compat ioctls possible?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091029083415.GA6639@osiris.boeblingen.de.ibm.com>
References: <200910281640.18491.arnd@arndb.de>
	<20091028.224157.92041844.davem@davemloft.net>
	<20091029083415.GA6639@osiris.boeblingen.de.ibm.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Thu, 29 Oct 2009 09:34:16 +0100

> Subject: [PATCH] fs: add missing compat_ptr handling for FS_IOC_RESVSP ioctl
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
> Reported-by: David Miller <davem@davemloft.net>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: David S. Miller <davem@davemloft.net>
