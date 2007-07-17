Return-Path: <linux-kernel-owner+w=401wt.eu-S1763369AbXGQJQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763369AbXGQJQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 05:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbXGQJQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 05:16:26 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33467 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbXGQJQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 05:16:25 -0400
Date: Tue, 17 Jul 2007 11:17:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [KBUILD] Whitelist references from __dbe_table to .init
Message-ID: <20070717091738.GB19679@uranus.ravnborg.org>
References: <20070710081632.GA10559@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710081632.GA10559@linux-mips.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 09:16:32AM +0100, Ralf Baechle wrote:
> This is needed on MIPS where the same mechanism as get_user() is used to
> intercept bus error exceptions for some hardware probes.  Without this
> patch modpost will throw spurious warnings:
> 
>   LD      vmlinux
>   SYSMAP  System.map
>   SYSMAP  .tmp_System.map
>   MODPOST vmlinux
> WARNING: arch/mips/sgi-ip22/built-in.o(__dbe_table+0x0): Section mismatch: reference to .init.text:

Applied,

	Sam
