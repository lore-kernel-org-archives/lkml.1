Return-Path: <linux-kernel-owner+w=401wt.eu-S1764935AbXJFSz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764935AbXJFSz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 14:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763020AbXJFSzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 14:55:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50545 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760961AbXJFSzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 14:55:13 -0400
Date: Sat, 6 Oct 2007 19:55:09 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, hch@lst.de, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch 1/9] compat_ioctl: move common block ioctls to compat_blkdev_ioctl
Message-ID: <20071006185509.GA30411@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>, Jens Axboe <jens.axboe@oracle.com>,
	linux-kernel@vger.kernel.org, davem@davemloft.net, hch@lst.de,
	Al Viro <viro@ftp.linux.org.uk>
References: <20071006181902.141862534@arndb.de> <20071006182342.566716634@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006182342.566716634@arndb.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2007 at 08:19:03PM +0200, Arnd Bergmann wrote:
> +static int compat_put_ushort(unsigned long arg, unsigned short val)
> +{
> +	return put_user(val, (unsigned short __user *)compat_ptr(arg));
> +}
> +
> +static int compat_put_int(unsigned long arg, int val)
> +{
> +	return put_user(val, (compat_int_t __user *)compat_ptr(arg));
> +}
> +
> +static int compat_put_long(unsigned long arg, long val)
> +{
> +	return put_user(val, (compat_long_t __user *)compat_ptr(arg));
> +}
> +
> +static int compat_put_ulong(unsigned long arg, compat_ulong_t val)
> +{
> +	return put_user(val, (compat_ulong_t __user *)compat_ptr(arg));
> +}
> +
> +static int compat_put_u64(unsigned long arg, u64 val)
> +{
> +	return put_user(val, (compat_u64 __user *)compat_ptr(arg));
> +}

These should probably be in compat.h

