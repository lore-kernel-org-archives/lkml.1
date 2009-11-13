Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbZKMOyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbZKMOyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 09:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbZKMOyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 09:54:01 -0500
Received: from mail.free-electrons.com ([88.191.76.200]:59117 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591AbZKMOyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 09:54:01 -0500
Date: Fri, 13 Nov 2009 15:54:00 +0100
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: Martin Michlmayr <tbm@cyrius.com>, sam@ravnborg.org
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       akpm@linux-foundation.org, hpa@zytor.com, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] Add support for LZO-compressed kernels for ARM
Message-ID: <20091113145349.GA2201@pc-ran3241.res.insa>
References: <1257942478-18719-1-git-send-email-albin.tonnerre@free-electrons.com>
 <1257942478-18719-2-git-send-email-albin.tonnerre@free-electrons.com>
 <1257942478-18719-3-git-send-email-albin.tonnerre@free-electrons.com>
 <20091112125938.GA19698@deprecation.cyrius.com>
 <20091113142917.GA12149@Chamillionaire.breakpoint.cc>
 <20091113145008.GN13296@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113145008.GN13296@deprecation.cyrius.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Nov 2009 14:50 +0000, Martin Michlmayr wrote :
> * Sebastian Andrzej Siewior <sebastian@breakpoint.cc> [2009-11-13 15:29]:
> > > # For __aeabi_uidivmod
> > >-lib1funcs = $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.o
> > >+lib1funcs = arch/$(SRCARCH)/lib/lib1funcs.o
> > 
> > +lib1funcs = $(obj)/arch/$(SRCARCH)/lib/lib1funcs.o
> > 
> > This is untested but it should refer to obj because you break out of
> > tree builds (O=) if you don't :)
> 
> With this I get:
>  make[4]: *** No rule to make target `arch/arm/boot/compressed/arch/arm/lib/lib1funcs.o', needed by `arch/arm/boot/compressed/vmlinux'.  Stop.

Sam: what's the correct way to solve this issue?

Regards,
-- 
Albin Tonnerre, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
