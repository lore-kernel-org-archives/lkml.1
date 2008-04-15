Return-Path: <linux-kernel-owner+w=401wt.eu-S1762512AbYDOJHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762512AbYDOJHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 05:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755754AbYDOJHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 05:07:30 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:59605 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761378AbYDOJH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 05:07:29 -0400
Date: Tue, 15 Apr 2008 12:06:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: hskinnemoen@atmel.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] avr32: don't offer CONFIG_GEN_RTC
Message-ID: <20080415090619.GA2454@cs181133002.pp.htv.fi>
References: <20080414141644.GC6695@cs181133002.pp.htv.fi> <426764.23035.qm@web65609.mail.ac4.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <426764.23035.qm@web65609.mail.ac4.yahoo.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 09:08:16PM -0400, Paul Gortmaker wrote:
> 
> --- Adrian Bunk <bunk@kernel.org> wrote:
> 
> > This patch fixes the following compile error:
> > 
> > <--  snip  -->
> > 
> > ...
> >   CC [M]  drivers/char/genrtc.o
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/char/genrtc.c:58:21:
> > error: asm/rtc.h: No such file or directory
> > ...
> > make[3]: *** [drivers/char/genrtc.o] Error 1
> > 
> > <--  snip  -->
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> I'm assuming this must be a randconfig error, as at
> a glance, nothing in arch/avr32/configs/* is setting
> GEN_RTC.
>...

Not randconfig, I tried allmodconfig.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

