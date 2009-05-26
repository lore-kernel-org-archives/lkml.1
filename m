Return-Path: <linux-kernel-owner+w=401wt.eu-S1759601AbZEZXem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601AbZEZXem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758254AbZEZXee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:34:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757425AbZEZXed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:34:33 -0400
Date: Tue, 26 May 2009 16:33:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, davej@redhat.com,
       sam@ravnborg.org, greg@kroah.com, randy.dunlap@oracle.com,
       kay.sievers@vrfy.org, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       mingo@elte.hu, mtk.manpages@gmail.com, hch@infradead.org,
       giometti@linux.it
Subject: Re: [PATCH 1/1] LinuxPPS core support.
Message-Id: <20090526163333.052026f6.akpm@linux-foundation.org>
In-Reply-To: <1242972753-22992-2-git-send-email-giometti@linux.it>
References: <1242972753-22992-1-git-send-email-giometti@linux.it>
	<1242972753-22992-2-git-send-email-giometti@linux.it>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009 08:12:33 +0200
Rodolfo Giometti <giometti@linux.it> wrote:

> This patch adds the kernel side of the PPS support currently named
> "LinuxPPS".
> 
> PPS means "pulse per second" and a PPS source is just a device which
> provides a high precision signal each second so that an application
> can use it to adjust system clock time.
> 
> Common use is the combination of the NTPD as userland program with a
> GPS receiver as PPS source to obtain a wallclock-time with
> sub-millisecond synchronisation to UTC.
> 
> To obtain this goal the userland programs shoud use the PPS API
> specification (RFC 2783 - Pulse-Per-Second API for UNIX-like Operating
> Systems, Version 1.0) which in part is implemented by this patch. It
> provides a set of chars devices, one per PPS source, which can be used
> to get the time signal. The RFC's functions can be implemented by
> accessing to these char devices.
>
> ...
>
>  Documentation/ABI/testing/sysfs-pps  |   73 ++++++++
>  Documentation/ioctl/ioctl-number.txt |    2 +
>  Documentation/pps/pps.txt            |  172 ++++++++++++++++++
>  MAINTAINERS                          |    7 +
>  drivers/Kconfig                      |    2 +
>  drivers/Makefile                     |    1 +
>  drivers/pps/Kconfig                  |   33 ++++
>  drivers/pps/Makefile                 |    8 +
>  drivers/pps/kapi.c                   |  329 ++++++++++++++++++++++++++++++++++
>  drivers/pps/pps.c                    |  312 ++++++++++++++++++++++++++++++++
>  drivers/pps/sysfs.c                  |   98 ++++++++++
>  include/linux/Kbuild                 |    1 +
>  include/linux/pps.h                  |  122 +++++++++++++
>  include/linux/pps_kernel.h           |   89 +++++++++

Well it seems that Christoph's header file suggestion was addressed.

It's been a long time and there have been many reviews and comments. 
Have you been keeping track of them all?

If so, can you please let us know which review comments remain
unaddressed, or were deliberately not addressed because you disagreed
with them?

Thanks.
