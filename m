Return-Path: <linux-kernel-owner+w=401wt.eu-S934612AbXJQQO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934612AbXJQQO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 12:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763083AbXJQQOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 12:14:17 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50850 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759842AbXJQQOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 12:14:16 -0400
Subject: Re: 2.6.23-git11 compile issues
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Ismail =?ISO-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200710171838.52243.ismail@pardus.org.tr>
References: <1192635199.14504.2.camel@dyn9047017100.beaverton.ibm.com>
	 <200710171838.52243.ismail@pardus.org.tr>
Content-Type: text/plain; charset=utf-8
Date: Wed, 17 Oct 2007 09:17:34 -0700
Message-Id: <1192637854.14504.3.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-17 at 18:38 +0300, Ismail Dönmez wrote:
> Wednesday 17 October 2007 Tarihinde 18:33:18 yazmıştı:
> > Known issue ?
> >
> >
> > Thanks,
> > Badari
> >
> >   CHK     include/linux/version.h
> >   CHK     include/linux/utsrelease.h
> >   CC      arch/x86/kernel/asm-offsets.s
> > In file included from arch/x86/kernel/asm-offsets_64.c:7,
> >                  from arch/x86/kernel/asm-offsets.c:4:
> > include/linux/crypto.h:20:24: error: asm/atomic.h: No such file or
> > directory In file included from include/linux/types.h:14,
> 
> Please try running make mrproper.

That fixed it. Thank you.

Thanks,
Badari

