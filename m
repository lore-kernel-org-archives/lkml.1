Return-Path: <linux-kernel-owner+w=401wt.eu-S933407AbXGPQxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407AbXGPQxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759792AbXGPQxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:53:06 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:51726 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbXGPQxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:53:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZOxy0RUTCP1JxU5Pqoa6nBSSwitwN0Fgx8hPswek/e2GeMLCELUXOuv7gNTPaDX8omymfwMn/ga6BxjDGAU3rPeEafXHGMqcc16wXWGNnKSSEs8R9N1X4jOW8/ZoLiIYLZRrHQTzJh1rlyT8HNxjHIcE22W0XudVyuFOaRbIFPc=
Message-ID: <961aa3350707160953y2c50ce44j5fb7fd8559120bae@mail.gmail.com>
Date: Tue, 17 Jul 2007 01:53:00 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH 1/10] sysfs: fix kmem_cache_free(NULL)
Cc: linux-kernel@vger.kernel.org, "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <20070716154335.GA29449@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070716134855.GA1858@APFDCB5C> <20070716135028.GA2040@APFDCB5C>
	 <20070716154335.GA29449@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/17, Greg KH <gregkh@suse.de>:
> On Mon, Jul 16, 2007 at 10:50:28PM +0900, Akinobu Mita wrote:
> > This patch fixes out of memory error handling in sysfs_new_dirent().
> > kmem_cache_free() with NULL is not allowed.
>
> Why not just allow kmem_cache_free() to allow NULL like other functions
> in the kernel?

It seems there was discussion about this and no conclusion
yet?

http://lkml.org/lkml/2007/3/19/42
