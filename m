Return-Path: <linux-kernel-owner+w=401wt.eu-S1760211AbXJQSsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211AbXJQSsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbXJQSsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:48:33 -0400
Received: from mail.fieldses.org ([66.93.2.214]:56382 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbXJQSsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:48:33 -0400
Date: Wed, 17 Oct 2007 14:48:18 -0400
To: Ismail =?utf-8?Q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Cc: Badari Pulavarty <pbadari@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-git11 compile issues
Message-ID: <20071017184818.GI2328@fieldses.org>
References: <1192635199.14504.2.camel@dyn9047017100.beaverton.ibm.com> <200710171838.52243.ismail@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200710171838.52243.ismail@pardus.org.tr>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 06:38:52PM +0300, Ismail Dönmez wrote:
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

I found it was enough just to remove the symlink:

	rm include/asm

and then build.

Took me longer than it should have to figure out what was going on,
though.

--b.
