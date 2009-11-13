Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZKMOuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZKMOuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 09:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbZKMOuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 09:50:13 -0500
Received: from sorrow.cyrius.com ([65.19.161.204]:34338 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbZKMOuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 09:50:12 -0500
Date: Fri, 13 Nov 2009 14:50:08 +0000
From: Martin Michlmayr <tbm@cyrius.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>,
       akpm@linux-foundation.org, hpa@zytor.com, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] Add support for LZO-compressed kernels for ARM
Message-ID: <20091113145008.GN13296@deprecation.cyrius.com>
References: <1257942478-18719-1-git-send-email-albin.tonnerre@free-electrons.com>
 <1257942478-18719-2-git-send-email-albin.tonnerre@free-electrons.com>
 <1257942478-18719-3-git-send-email-albin.tonnerre@free-electrons.com>
 <20091112125938.GA19698@deprecation.cyrius.com>
 <20091113142917.GA12149@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113142917.GA12149@Chamillionaire.breakpoint.cc>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <sebastian@breakpoint.cc> [2009-11-13 15:29]:
> > # For __aeabi_uidivmod
> >-lib1funcs = $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.o
> >+lib1funcs = arch/$(SRCARCH)/lib/lib1funcs.o
> 
> +lib1funcs = $(obj)/arch/$(SRCARCH)/lib/lib1funcs.o
> 
> This is untested but it should refer to obj because you break out of
> tree builds (O=) if you don't :)

With this I get:
 make[4]: *** No rule to make target `arch/arm/boot/compressed/arch/arm/lib/lib1funcs.o', needed by `arch/arm/boot/compressed/vmlinux'.  Stop.

-- 
Martin Michlmayr
http://www.cyrius.com/
