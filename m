Return-Path: <linux-kernel-owner+w=401wt.eu-S1760435AbXESN0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760435AbXESN0h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 09:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757551AbXESN0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 09:26:30 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:46713 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757483AbXESN0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 09:26:30 -0400
Date: Sat, 19 May 2007 15:27:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2: section mismatch
Message-ID: <20070519132727.GA23370@uranus.ravnborg.org>
References: <200705191443.27161.arvidjaar@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705191443.27161.arvidjaar@mail.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 02:43:21PM +0400, Andrey Borzenkov wrote:
>   MODPOST vmlinux
> WARNING: init/built-in.o - Section mismatch: reference to .init.text: 
> from .text between 'rest_init' (at offset 0x11b) and 'try_name'
Fixed in kbuild.fix.git.

> WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference 
> to .init.text:amd_init_mtrr from .text between 'mtrr_bp_init' (at offset 
> 0x967a) and 'mtrr_attrib_to_str'
> WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference 
> to .init.text:cyrix_init_mtrr from .text between 'mtrr_bp_init' (at offset 
> 0x967f) and 'mtrr_attrib_to_str'
> WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference 
> to .init.text:centaur_init_mtrr from .text between 'mtrr_bp_init' (at offset 
> 0x9684) and 'mtrr_attrib_to_str'

mtrr_bp_init() should be declared __init

> WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference 
> to .init.text: from .text between 'get_mtrr_state' (at offset 0xa735) 
> and 'generic_get_mtrr'
> WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference 
> to .init.text: from .text between 'get_mtrr_state' (at offset 0xa749) 
> and 'generic_get_mtrr'
> WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference 
> to .init.text: from .text between 'get_mtrr_state' (at offset 0xa770) 
> and 'generic_get_mtrr'

get_mtrr_state should be declared __init

> WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text 
> between 'kmem_cache_create' (at offset 0x1bffd) and 'cache_reap'
> WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text 
> between 'kmem_cache_create' (at offset 0x1c232) and 'cache_reap'

Fixed in kbuild-git.git

	Sam

