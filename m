Return-Path: <linux-kernel-owner+w=401wt.eu-S933792AbXHFPGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933792AbXHFPGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932787AbXHFPGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:06:03 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48693 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761765AbXHFPGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:06:01 -0400
Date: Mon, 6 Aug 2007 17:02:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Alex Smith <alex.frugalware@googlemail.com>
Cc: tla <tla@oak.selfip.net>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2 compile warnings & 1 section mismatch
Message-ID: <20070806150245.GA29167@uranus.ravnborg.org>
References: <46B4B529.5060402@oak.selfip.net> <dc34eaad0708060738o67dec417s9ada429fa41dbd56@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc34eaad0708060738o67dec417s9ada429fa41dbd56@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 03:38:37PM +0100, Alex Smith wrote:
> On 04/08/07, tla <tla@oak.selfip.net> wrote:
> > Hi,
> >
> >   The following warnings (17) and section mismatch (1) were observed
> > when compiling linux 2.6.23-rc2.
> >
> *snip*
> >   LD      .tmp_vmlinux1
> >   KSYM    .tmp_kallsyms1.S
> >   AS      .tmp_kallsyms1.o
> >   LD      .tmp_vmlinux2
> >   KSYM    .tmp_kallsyms2.S
> >   AS      .tmp_kallsyms2.o
> >   LD      vmlinux.o
> >   MODPOST vmlinux.o
> > WARNING: vmlinux.o(.text+0x183): Section mismatch: reference to
> > .init.text:start_kernel (between 'is386' and 'check_x87')
> >   LD      vmlinux
> >   SYSMAP  System.map
> >   SYSMAP  .tmp_System.map
> 
> I can confirm this section mismatch. I got it while building from
> latest (today) linux-2.6.git.
It is a false positive. But as it originates from assembler it is less trivial
to fix so queued for later.
Please ignore for now.

But that said please report all new warnings - this is helpfull.

	Sam
