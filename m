Return-Path: <linux-kernel-owner+w=401wt.eu-S1759560AbYEOWwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560AbYEOWwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 18:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbYEOWv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 18:51:56 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33773 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbYEOWvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 18:51:55 -0400
Date: Fri, 16 May 2008 01:50:10 +0300
From: Adrian Bunk <bunk@kernel.org>
To: debian developer <debiandev@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26-rc2 - ntp.c build failure
Message-ID: <20080515225010.GK1936@cs181133002.pp.htv.fi>
References: <f24d23310805120313o6385ff7av148aa109b2408ed7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f24d23310805120313o6385ff7av148aa109b2408ed7@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 03:43:45PM +0530, debian developer wrote:
> Hi Roman,
> 
> The current rc2 does not build with allyesconfig. Seems there are lots
> of errors...

Works here.

Please send your .config

> Please find the error log below...
> 
> kernel/time/ntp.c: In function `ntp_leap_second':
> kernel/time/ntp.c:150: error: `time_tai' undeclared (first use in this function)
> kernel/time/ntp.c:150: error: (Each undeclared identifier is reported only once
> kernel/time/ntp.c:150: error: for each function it appears in.)
> kernel/time/ntp.c: In function `do_adjtimex':
> kernel/time/ntp.c:328: error: `SHIFT_NSEC' undeclared (first use in
> this function)
> kernel/time/ntp.c:378: error: `mtemp' undeclared (first use in this function)
> kernel/time/ntp.c:381: error: `freq_adj' undeclared (first use in this function)
> kernel/time/ntp.c:382: warning: type defaults to `int' in declaration of `__x'
> kernel/time/ntp.c:382: warning: type defaults to `int' in declaration of `__s'
> kernel/time/ntp.c:386: error: `temp64' undeclared (first use in this function)
> kernel/time/ntp.c:398: warning: type defaults to `int' in declaration of `_min1'
> kernel/time/ntp.c:398: error: `MAXFREQ_NSEC' undeclared (first use in
> this function)
> kernel/time/ntp.c:398: warning: type defaults to `int' in declaration of `_min2'
> kernel/time/ntp.c:399: warning: type defaults to `int' in declaration of `_max1'
> kernel/time/ntp.c:399: warning: type defaults to `int' in declaration of `_max2'
> kernel/time/ntp.c:400: error: implicit declaration of function
> `div_long_long_rem_signed'
> kernel/time/ntp.c:402: error: `rem' undeclared (first use in this function)
> kernel/time/ntp.c:403: error: `SHIFT_UPDATE' undeclared (first use in
> this function)
> kernel/time/ntp.c:419: warning: type defaults to `int' in declaration of `__s'
> kernel/time/ntp.c:279: warning: unused variable `sec'
> kernel/time/ntp.c: At top level:
> kernel/time/ntp.c:65: warning: 'ntp_update_offset' defined but not used
> make[2]: *** [kernel/time/ntp.o] Error 1
> make[1]: *** [kernel/time] Error 2
> make: *** [kernel] Error 2

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

