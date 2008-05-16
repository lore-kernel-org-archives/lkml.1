Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbYEPRmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbYEPRmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbYEPRmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:42:35 -0400
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:1686 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbYEPRmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:42:35 -0400
Date: Fri, 16 May 2008 19:42:30 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: debian developer <debiandev@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26-rc2 - ntp.c build failure
In-Reply-To: <f24d23310805120313o6385ff7av148aa109b2408ed7@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805161937381.18302@localhost.localdomain>
References: <f24d23310805120313o6385ff7av148aa109b2408ed7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 12 May 2008, debian developer wrote:

> The current rc2 does not build with allyesconfig. Seems there are lots
> of errors...
> 
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

Please use a clean source tree, a few of these symbols don't exist 
anymore.

bye, Roman
