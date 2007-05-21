Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbXEUEyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbXEUEyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 00:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbXEUEyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 00:54:47 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:50977 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbXEUEyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 00:54:46 -0400
Date: Mon, 21 May 2007 06:55:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Dan Kruchinin <dubalom@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.22-rc1-mm1] section mismatch.
Message-ID: <20070521045544.GB30018@uranus.ravnborg.org>
References: <1179716508.4625.6.camel@midgard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179716508.4625.6.camel@midgard>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 07:01:48AM +0400, Dan Kruchinin wrote:
> Hi.
> 
> Section mismatch:
> --
> WARNING: init/built-in.o - Section mismatch: reference to .init.text:
> from .text between 'rest_init' (at offset 0x11e) and 'try_name'
> WARNING: arch/i386/mach-generic/built-in.o - Section mismatch: reference
> to .init.text: from .data between 'apic_bigsmp' (at offset 0xc4) and
> 'cpu.5773'
> WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference
> to .init.text:amd_init_mtrr from .text between 'mtrr_bp_init' (at offset
> 0xe3ea) and 'ipi_handler'
> WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference
> to .init.text:cyrix_init_mtrr from .text between 'mtrr_bp_init' (at
> offset 0xe3ef) and 'ipi_handler'
> WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference
> to .init.text:centaur_init_mtrr from .text between 'mtrr_bp_init' (at
> offset 0xe3f4) and 'ipi_handler'
> --

Patches for all these are queued up for next -mm.
But thank you for reporting anyway.

	Sam
