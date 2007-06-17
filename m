Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbXFQQPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbXFQQPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 12:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXFQQPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 12:15:39 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:47512 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbXFQQPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 12:15:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FmnS/cA1R1CfkP943/tI0tArV3XeYZzzxVW+84Ov48SAUF5sxdSPm2PnBd5hLgcXFREpgiGtuZoxyEiW+iOIUBKwY1c4XE41AcSU6oTqoBRcz7usgFUXwmRCrbBkiaFvlZzIOCIFYK+460Numag0oB2/vhjSR/RUDQOcXg8fbOg=
Message-ID: <2accc2ff0706170915h7cc0ce97ofc16bc33f1714567@mail.gmail.com>
Date: Sun, 17 Jun 2007 11:15:35 -0500
From: "Nelson Castillo" <nelsoneci@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: v2.6.21.4-rt11
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20070609210507.GA29194@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070609210507.GA29194@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/9/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> i'm pleased to announce the v2.6.21.4-rt11 kernel, which can be
> downloaded from the usual place:
>
>      http://people.redhat.com/mingo/realtime-preempt/
>
> more info about the -rt patchset can be found in the RT wiki:
>
>      http://rt.wiki.kernel.org

Not for ARM yet :(

What should I try for the ARM architecture? There are many choices and
I don't know what is the more friendly. By friendly I mean the one that
is likely to be merged and that cooperate with you.

> to build a 2.6.21.4-rt11 tree, the following patches should be applied:
>
>     http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.21.4.tar.bz2
>     http://people.redhat.com/mingo/realtime-preempt/patch-2.6.21.4-rt11
>


Using this patch:

  http://people.redhat.com/mingo/realtime-preempt/patch-2.6.21.4-rt14

  LD      init/built-in.o
  LD      .tmp_vmlinux1
kernel/built-in.o(.text+0xd3f0): In function `do_sys_settimeofday':
: undefined reference to `warp_check_clock_was_changed'
kernel/built-in.o(.text+0x12588): In function `timekeeping_resume':
: undefined reference to `warp_check_clock_was_changed'
kernel/built-in.o(.text+0x132f8): In function `do_sysinfo':
: undefined reference to `__get_nsec_offset'
kernel/built-in.o(.text+0x20a04): In function `ktime_get_ts':
: undefined reference to `__get_nsec_offset'
kernel/built-in.o(.text+0x221c0): In function `$a':
: undefined reference to `warp_check_clock_was_changed'
kernel/built-in.o(.text+0x22208): In function `$a':
: undefined reference to `warp_check_clock_was_changed'
kernel/built-in.o(.text+0x2b9dc): In function `$a':
: undefined reference to `usecs_to_cycles'
make: *** [.tmp_vmlinux1] Error 1

Regards.

-- 
http://arhuaco.org
http://emQbit.com
