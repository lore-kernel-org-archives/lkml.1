Return-Path: <linux-kernel-owner+w=401wt.eu-S932536AbXC2RYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbXC2RYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 13:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933166AbXC2RYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 13:24:09 -0400
Received: from smtp.osdl.org ([65.172.181.24]:33446 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536AbXC2RYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 13:24:06 -0400
Date: Thu, 29 Mar 2007 10:23:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: 2.6.21-rc5-mm2
Message-Id: <20070329102328.230233eb.akpm@linux-foundation.org>
In-Reply-To: <1175190807.13420.1.camel@dyn9047017100.beaverton.ibm.com>
References: <20070326211627.c681af3b.akpm@linux-foundation.org>
	<1175190807.13420.1.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007 09:53:27 -0800 Badari Pulavarty <pbadari@gmail.com> wrote:

> On Mon, 2007-03-26 at 21:16 -0800, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/
> > 
> > 
> > - This is the same as 2.6.12-rc5-mm1, except the staircase deadline CPU
> >   scheduler has been added.
> 
> make allyesconfig - didn't give me a clean build :(
> (not crucial for me to get it right -- but FYI).
> 
> Thanks,
> Badari
> 
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CHK     include/linux/compile.h
>   CC      drivers/net/e100.o
>   LD      drivers/net/wireless/built-in.o
>   CC      drivers/net/epic100.o
>   CC      drivers/net/sis190.o
> drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
> drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_chip_switch_radio_on'
>   CC      drivers/net/sis900.o
> drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
> drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
>
> [zillions more errors]

yeah, not surprised.

John, please test allyesconfig ;)
