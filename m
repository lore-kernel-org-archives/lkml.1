Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbZHaMaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbZHaMaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbZHaMaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:30:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56195 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZHaMaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:30:08 -0400
Date: Mon, 31 Aug 2009 08:30:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs compat_ioctl?
Message-ID: <20090831123010.GA2368@infradead.org>
References: <4A9B759B.7020401@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9B759B.7020401@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 11:02:51AM +0400, Michael Tokarev wrote:
> Hello!
>
> I tried to resize an xfs filesystem on 64bit 2.6.30 kernel
> using 32bit userland, and that does not work, in dmesg I see:
>
> ioctl32(xfs_growfs:24426): Unknown cmd fd(3) cmd(400c586e){t:'X';sz:12} arg(ffa56df4) on /mnt
> ioctl32(xfs_growfs:24427): Unknown cmd fd(3) cmd(400c586e){t:'X';sz:12} arg(ff991254) on /mnt
>
> so apparently there's no compat_ioctl layer for these ioctls.
>
> Are there any plans to add these? :)

Are you sure you're testing 2.6.30?  The copat ioctls were added in
2.6.28.
