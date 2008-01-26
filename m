Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbYAZWZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbYAZWZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 17:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbYAZWZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 17:25:09 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:45248 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbYAZWZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 17:25:08 -0500
Date: Sat, 26 Jan 2008 23:25:18 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: build warning in 2.6.24: section mismatch
Message-ID: <20080126222518.GA27060@uranus.ravnborg.org>
References: <18331.45568.100640.631471@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18331.45568.100640.631471@fisica.ufpr.br>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 08:19:44PM -0200, Carlos Carvalho wrote:
> Near the end of the build this appears:
> 
>   KSYM    .tmp_kallsyms2.S
>   AS      .tmp_kallsyms2.o
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: vmlinux.o(.text.head+0xe4): Section mismatch: reference to .init.data.2:trampoline_level4_pgt (between 'ident_complete' and 'secondary_startup_64')
> WARNING: vmlinux.o(.text.head+0xeb): Section mismatch: reference to .init.data.2:trampoline_level4_pgt (between 'ident_complete' and 'secondary_startup_64')
>   LD      vmlinux
>   SYSMAP  System.map
> 
> What does this mean?
In this case a harmless warning - please ignore.
We have a patch pending to fix this one.

	Sam
