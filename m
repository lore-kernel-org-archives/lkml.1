Return-Path: <linux-kernel-owner+w=401wt.eu-S933499AbXFEXP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499AbXFEXP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 19:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763290AbXFEXPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 19:15:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:36225 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760777AbXFEXPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 19:15:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=XW3dzd3Kh6ABgilPt8qcCGBLO5bhMFUKUkNlIyqyzYhav7cQG+CNwvqEv/rDsJBrfnZYK1BDkXPv8Mo/JB3hOCWBMJeZLRt+Fdgbn0m6o+M6VtTjd9H0DL5Zv+pEaPAcKPPFndoXMyxWkkkRh2hilvVFITWZlEOkWjEP8QI0FrQ=
Message-ID: <b6a2187b0706051615t1d63ac2cga25ebe54281bd4a0@mail.gmail.com>
Date: Wed, 6 Jun 2007 07:15:45 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.22-rc4: known regressions [section mismatch]
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton LKML" <linux-kernel@vger.kernel.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/2/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> I think that Sam is working on this.
> http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git&a=search&h=f285e3d329ce68cc355fadf4ab2c8f34d7f264cb&st=commit&s=section+mismatch

I still got the section mismatch errors on 2.6.22-rc4. Here's the details ...

WARNING: arch/i386/kernel/built-in.o(.text+0x9c7f): Section mismatch:
reference to .init.text: (between 'init_intel_cacheinfo' and
'cache_shared_cpu_map_setup')
WARNING: arch/i386/kernel/built-in.o(.text+0xae43): Section mismatch:
reference to .init.text: (between 'mtrr_bp_init' and 'mtrr_ap_init')
WARNING: arch/i386/kernel/built-in.o(.text+0xafb1): Section mismatch:
reference to .init.text: (between 'mtrr_bp_init' and 'mtrr_ap_init')
WARNING: arch/i386/kernel/built-in.o(.text+0xafb6): Section mismatch:
reference to .init.text: (between 'mtrr_bp_init' and 'mtrr_ap_init')
WARNING: arch/i386/kernel/built-in.o(.text+0xb97d): Section mismatch:
reference to .init.text: (between 'get_mtrr_state' and 'mtrr_wrmsr')
WARNING: kernel/built-in.o(.text+0x17a93): Section mismatch: reference
to .init.text: (between 'kthreadd' and 'init_waitqueue_head')


Only happens after recompile.

Thanks,
Jeff.
