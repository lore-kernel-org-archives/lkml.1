Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbZEVOzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbZEVOzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 10:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbZEVOy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 10:54:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbZEVOy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 10:54:57 -0400
Date: Fri, 22 May 2009 16:54:58 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org
Subject: Re: Rich man's version of AIO on Linux 2.6.x?
Message-ID: <20090522145457.GC7234@tiehlicka.suse.cz>
References: <c384c5ea0905211759v11408a03o570980a34d02f0ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c384c5ea0905211759v11408a03o570980a34d02f0ff@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 22-05-09 02:59:53, Leon Woestenberg wrote:
> Hello,

Hi

> 
> On the state-of-art of asynchronous I/O in Linux. I understand we have
> full support for AIO in the Linux 2.6.x kernel but I cannot find how
> to use it from user space.
> 
> 
> I would like to exploit AIO in hardware and the device driver for it,
> by keeping the hardware performing I/O at all times (no setup latency
> between requests by allowing multiple
> I/O requests to be queued in hardware). Note this is a character
> device, not a filesystem.
> 
> I implemented aio_read() and aio_write() on my character device
> interface, but it's never been called; read() and write() is called
> instead.
> 
> From "Understanding the Linux kernel, 3rd edition" I read that glibc
> indeed implements aio_read() and friends itself, not through the
> kernel AIO syscalls.
> 
> <Quote>
> Essentially, the aio_read( ) or aio_write( ) library function clones
> the current process and lets the child invoke the synchronous read( )
> or write( ) system calls; However, this "poor man's" version of the
> POSIX functions is significantly slower than a version that uses a
> kernel-level implementation of asynchronous I/O.
> <End Quote>
> 
> I am looking for a rich man's way to use the kernel functionality;
> essentially I want my drivers aio_read and aio_write ops to be called.

Check the libaio library (io_submit and friends)

> 
> Regards,
> -- 
> Leon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
