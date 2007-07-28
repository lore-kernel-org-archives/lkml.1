Return-Path: <linux-kernel-owner+w=401wt.eu-S1763226AbXG1GYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763226AbXG1GYl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 02:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbXG1GYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 02:24:33 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49702 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038AbXG1GYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 02:24:33 -0400
Date: Sat, 28 Jul 2007 08:25:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc1-mm1 + hotfixes -- Section mismatches
Message-ID: <20070728062549.GB21626@uranus.ravnborg.org>
References: <a44ae5cd0707272216o60185470k30a785ebbffe57f5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44ae5cd0707272216o60185470k30a785ebbffe57f5@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 10:16:35PM -0700, Miles Lane wrote:
>   MODPOST vmlinux.o
> WARNING: vmlinux.o(.text+0x183): Section mismatch: reference to
> .init.text.1:start_kernel (between 'is386' and 'check_x87')

This one is not fixed - yet.

The rest are fixed in latest -linus.
modpost choked over the added number following the section name.
Like in .init.text.4 below.
                  ^^

> WARNING: vmlinux.o(.data+0x53c0): Section mismatch: reference to
> .init.text.4:native_smp_prepare_boot_cpu (between 'smp_ops' and
> 'call_lock')

	Sam
