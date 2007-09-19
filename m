Return-Path: <linux-kernel-owner+w=401wt.eu-S1762220AbXISQxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762220AbXISQxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762012AbXISQxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:53:22 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1593 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761898AbXISQxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:53:21 -0400
Date: Wed, 19 Sep 2007 17:52:50 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1 -- powerpc link failure
Message-ID: <20070919165250.GD2519@shadowen.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070919092848.GG973@shadowen.org> <24129b460390d93b37ee4cf21d6a5db1@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24129b460390d93b37ee4cf21d6a5db1@kernel.crashing.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 06:36:29PM +0200, Segher Boessenkool wrote:
> >I am seeing this strange link error from a PowerMac G5 (powerpc):
> >
> >  [...]
> >    KSYM    .tmp_kallsyms2.S
> >    AS      .tmp_kallsyms2.o
> >    LD      vmlinux.o
> >  ld: dynreloc miscount for fs/built-in.o, section .opd
> >  ld: can not edit opd Bad value
> >  make: *** [vmlinux.o] Error 1
> >
> >Compiler version below.
> 
> It's an ld error, could you show us your ld version instead?  And
> please try with current mainline ld, too?

root@elm3b19:~# ld -v
GNU ld version 2.16.91 20060118 Debian GNU/Linux

Getting the compiler suite changed on here is going to be a lot
tricker.  One of the reasons we keep it back there is those versions
are supposed to be supported and we want to test those combinations.

-apw
