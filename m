Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbXLCKCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbXLCKCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 05:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbXLCKC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 05:02:26 -0500
Received: from ozlabs.org ([203.10.76.45]:55789 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbXLCKCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 05:02:25 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Correct types for mod_devicetable.h (was: Re: m68k build failure)
Date: Mon, 3 Dec 2007 21:02:19 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Pierre Ossman <drzeus@drzeus.cx>, Al Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Marcel Holtmann <marcel@holtmann.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org> <20071201215602.7a4710d9@poseidon.drzeus.cx> <Pine.LNX.4.64.0712021219430.29349@anakin>
In-Reply-To: <Pine.LNX.4.64.0712021219430.29349@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712032102.20353.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 December 2007 22:22:31 Geert Uytterhoeven wrote:
> On Sat, 1 Dec 2007, Pierre Ossman wrote:
> > Yeah, that could work. Have a header with stuff like this:
> >
> > typedef u16 __attribute__((aligned(2))) aligned_u16;
> > typedef u32 __attribute__((aligned(4))) aligned_u32;
>
> I gave it a try:

This seems to turn a molehill into a mountain.

We can change that mod_devicetable.h at any time; it's not supposed to be a 
userspace API (the kernel build system doesn't count).

So, just insert two bits of padding in sdio_device_id and insert a comment 
saying "/* Explicit padding: works even if we're cross-compiling */".

Thanks,
Rusty.
