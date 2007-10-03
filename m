Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbXJCAZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbXJCAZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 20:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbXJCAZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 20:25:08 -0400
Received: from main.gmane.org ([80.91.229.2]:39497 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbXJCAZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 20:25:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: build error
Date: Tue, 2 Oct 2007 17:19:42 -0700
Organization: Linux Foundation
Message-ID: <20071002171942.047450fe@freepuppy.rosehill>
References: <20071002201213.GA5605@chaos.in-kiel.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 069-064-229-129.pdx.net
In-Reply-To: <20071002201213.GA5605@chaos.in-kiel.de>
X-Newsreader: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007 22:12:13 +0200
linux-kernel@lebenslange-mailadresse.de wrote:

> [please CC: me, my subscribe mail was greylisted]
> 
> Morning!
> 
> My make run for 2.6.23-rc9 ends like this:
> 
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> kernel/built-in.o: In function `getnstimeofday':
> (.text+0x1e141): undefined reference to `__udivdi3'
> kernel/built-in.o: In function `do_gettimeofday':
> (.text+0x1e263): undefined reference to `__udivdi3'
> kernel/built-in.o: In function `timekeeping_resume':
> timekeeping.c:(.text+0x1e427): undefined reference to `__udivdi3'
> kernel/built-in.o: In function `update_wall_time':
> (.text+0x1e829): undefined reference to `__udivdi3'
> kernel/built-in.o: In function `update_wall_time':
> (.text+0x1ec4c): undefined reference to `__udivdi3'
> make: *** [.tmp_vmlinux1] Error 1
> 
> .config attached.
> 
> I have already read the diff from -rc8 and found nothing that helped me.
> 
> Any ideas? Further questions?
> 
> Wilfried
> 

What Gcc version? and config/architecture?

-- 
Stephen Hemminger <shemminger@linux-foundation.org>

