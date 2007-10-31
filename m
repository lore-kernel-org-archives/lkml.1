Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbXJaKsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbXJaKsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbXJaKrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:47:55 -0400
Received: from nic2.axis.se ([193.13.178.10]:58554 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336AbXJaKry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:47:54 -0400
Date: Wed, 31 Oct 2007 11:47:38 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mikael.starvik@axis.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/16] CRIS architecture: Correct compile errors
Message-ID: <20071031104738.GW11960@axis.com>
References: <20071030092811.GD11960@axis.com> <20071030151400.e4769e27.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030151400.e4769e27.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 03:14:00PM -0700, Andrew Morton wrote:
> On Tue, 30 Oct 2007 10:28:11 +0100
> Jesper Nilsson <jesper.nilsson@axis.com> wrote:
> 
> > Remove include of asm/bitops.h, not needed here, corrects compilation error
> > (__le64 undefined).
> [snip]
>
> This doesn't apply and I'm not sure that it is still needed or correct.
> 
> I'll drop it.

Unfortunately it is still needed, I'll resend a fresh patch
against Linus git tree.

Compile error:

  CC      arch/cris/kernel/asm-offsets.s
In file included from include/asm/byteorder.h:23,
                 from include/asm-generic/bitops/le.h:5,
                 from include/asm-generic/bitops/ext2-non-atomic.h:4,
                 from include/asm/bitops.h:163,
                 from include/linux/bitops.h:17,
                 from include/asm/posix_types.h:55,
                 from include/linux/posix_types.h:47,
                 from include/linux/types.h:11,
                 from include/linux/capability.h:16,
                 from include/linux/sched.h:49,
                 from arch/cris/kernel/asm-offsets.c:1:
include/linux/byteorder/little_endian.h:43: parse error before "__cpu_to_le64p"
include/linux/byteorder/little_endian.h:44: warning: return type defaults to `int'
include/linux/byteorder/little_endian.h: In function `__cpu_to_le64p':
include/linux/byteorder/little_endian.h:45: `__le64' undeclared (first use in this function)
....

> Please always prepare and test patches against the latest kernel.  2.6.23
> is very much _not_ the latest kernel - there is a 50MB diff between 2.6.23
> and 2.6.24-rc1.  That's a lot of difference.

I will do so from now on.

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
