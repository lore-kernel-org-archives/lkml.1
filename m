Return-Path: <linux-kernel-owner+w=401wt.eu-S1764948AbXHAMaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764948AbXHAMaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 08:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761022AbXHAMaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 08:30:00 -0400
Received: from ozlabs.org ([203.10.76.45]:59763 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760408AbXHAM37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 08:29:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18096.24918.111376.805855@cargo.ozlabs.ibm.com>
Date: Wed, 1 Aug 2007 20:32:54 +1000
From: Paul Mackerras <paulus@samba.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, gregkh@suse.de,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.23-rc1-mm2
In-Reply-To: <200708011002.30962.m.kozlowski@tuxland.pl>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	<200708011002.30962.m.kozlowski@tuxland.pl>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Kozlowski writes:

> Second issue as reported earilier allmodconfig fails to build on imac g3.

Do you really mean g3?  If so it's a 32-bit kernel and it shouldn't be
building lparmap.s.  Or do you mean G5?

>   CC      arch/powerpc/kernel/lparmap.s
>   AS      arch/powerpc/kernel/head_64.o
> lparmap.c: Assembler messages:
> lparmap.c:84: Error: file number 1 already allocated
> make[1]: *** [arch/powerpc/kernel/head_64.o] Blad 1
> make: *** [arch/powerpc/kernel] Blad 2

Weird.  Could you do make V=1 and send me the output?

Paul.
