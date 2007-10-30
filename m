Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbXJ3NKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbXJ3NKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 09:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbXJ3NKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 09:10:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37097 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbXJ3NKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 09:10:38 -0400
Date: Tue, 30 Oct 2007 13:10:32 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 32bit builds on x86-64 host.
Message-ID: <20071030131032.GA32366@infradead.org>
References: <20071029233231.GI7793@redhat.com> <472675AC.3070509@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472675AC.3070509@zytor.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 05:07:08PM -0700, H. Peter Anvin wrote:
> Dave Jones wrote:
> >Before the arch merge, I frequently would test 32bit compiles
> >by doing make ARCH=i386 {bzImage/modules/file.o}
> >
> >Since commit 47572387d58a9584c60ebbbdee56fc92c627f16f
> >how does one do this?
> >
> 
> make ARCH=i386 {bzImage/modules/file.o}

Which seems rather unnatural to me.  All other merge architectures have
ARCH=<archdir> where archdir is the name under arch, e.g. mips, powerpc,
s390.  They then have a CONFIG_FOO_64 and set the utsname and -m32/-m64
respectively.  It would be nice if x86 could behave like all other
architectures in this respect.  Especially as the behaviour of the other
architectures is a lot more intuitive.

> 
> Amazing, isn't it?
> 
> 	-hpa
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
---end quoted text---
