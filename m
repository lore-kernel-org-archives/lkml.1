Return-Path: <linux-kernel-owner+w=401wt.eu-S940855AbXHJSo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940855AbXHJSo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 14:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbXHJSop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 14:44:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50008 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753790AbXHJSoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 14:44:44 -0400
Date: Fri, 10 Aug 2007 11:44:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: arch/i386/kernel/setup.c - compile error (Re: 2.6.23-rc2-mm2)
Message-Id: <20070810114435.c6353b2a.akpm@linux-foundation.org>
In-Reply-To: <46BCA6A9.6000402@googlemail.com>
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<46BCA6A9.6000402@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 19:55:53 +0200
Gabriel C <nix.or.die@googlemail.com> wrote:

> 
> >  git-newsetup.patch
> 
> ...
> 
> arch/i386/kernel/setup.c: In function 'setup_arch':
> arch/i386/kernel/setup.c:547: error: 'PARAM' undeclared (first use in this function)
> arch/i386/kernel/setup.c:547: error: (Each undeclared identifier is reported only once
> arch/i386/kernel/setup.c:547: error: for each function it appears in.)
> make[1]: *** [arch/i386/kernel/setup.o] Error 1
> make: *** [arch/i386/kernel] Error 2
> make: *** Waiting for unfinished jobs....
>  
> ....
> 
> Got it on a randconfig :
> 
> http://194.231.229.228/kernel/mm/2.6.23-rc2-mm2/randconfig-auto-25

PARAM got removed, but include/asm-i386/mach-voyager/setup_arch.h still
uses it.


