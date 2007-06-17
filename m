Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbXFQCsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbXFQCsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 22:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXFQCsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 22:48:38 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:39631 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbXFQCsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 22:48:37 -0400
Date: Sun, 17 Jun 2007 11:47:06 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: linuxsh-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc4 not compiling on the SH4/Dreamcast
Message-ID: <20070617024706.GA6922@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	linuxsh-dev@lists.sourceforge.net,
	LKML <linux-kernel@vger.kernel.org>
References: <1182025451.6018.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182025451.6018.22.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 09:24:11PM +0100, Adrian McMenamin wrote:
> This is a patched 2.6.21.5 - which might be an issue. But this is what I
> get:
> 
> LD      .tmp_vmlinux1
> arch/sh/kernel/built-in.o: In function `restore_all':
> arch/sh/kernel/cpu/sh4/../sh3/entry.S:(.text+0x50cc): undefined
> reference to `in_nmi'
> make: *** [.tmp_vmlinux1] Error 1
> 
Fixed in current git. You can either toss an ifdef around the label or
simply enable KGDB if you wish to work around it in the interim, or
barring that, wait for -rc5.
