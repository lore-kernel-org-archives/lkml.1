Return-Path: <linux-kernel-owner+w=401wt.eu-S1759054AbYEYUUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054AbYEYUUy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 16:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbYEYUUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 16:20:44 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:38929 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbYEYUUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 16:20:44 -0400
Date: Sun, 25 May 2008 23:18:07 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mirco Tischler <mt-ml@gmx.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [BUG: 2.6.26-rc3] ERROR: "____ilog2_NaN" undefined
Message-ID: <20080525201807.GK1791@cs181133002.pp.htv.fi>
References: <1211735607.14556.14.camel@mtlp.tischlernetz> <20080525181118.GG1791@cs181133002.pp.htv.fi> <1211742202.14556.25.camel@mtlp.tischlernetz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1211742202.14556.25.camel@mtlp.tischlernetz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2008 at 09:03:22PM +0200, Mirco Tischler wrote:
> On So, 2008-05-25 at 21:11 +0300, Adrian Bunk wrote:
> > Works for me with your .config.
> > 
> > You are using an unmodified 2.6.26-rc3 kernel?
> Yes. I just pulled today.
> > 
> > If yes, please:
> > - send the output of "bash ./scripts/ver_linux" and
> ﻿$ ./scripts/ver_linux
> ﻿If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
> 
> Linux mtlp 2.6.26-rc3-experimental #18 SMP PREEMPT Thu May 22 21:17:47
> CEST 2008 x86_64 GNU/Linux
> 
> Gnu C                  4.3.0-4ubuntu1)
>...

I'd have said your gcc has a bug regarding __builtin_constant_p(),
but I can't reproduce it on i386 with the compiler you are using.

You are using exactly this compiler for compiling your kernel?

If yes I'm unfortunately out of ideas...  :-(

> Thanks
> Mirco

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

