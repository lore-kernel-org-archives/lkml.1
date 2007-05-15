Return-Path: <linux-kernel-owner+w=401wt.eu-S933482AbXEOJfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482AbXEOJfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 05:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759952AbXEOJfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 05:35:00 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:34495 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759926AbXEOJe7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 05:34:59 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH 1/2] kbuild: Add "Section mismatch" warning whitelist for powerpc
Date: Tue, 15 May 2007 17:36:40 +0800
Message-ID: <989B956029373F45A0B8AF0297081890B76041@zch01exm26.fsl.freescale.net>
In-Reply-To: <3DF58590-DFD9-4665-8C47-33F407AAD1E7@kernel.crashing.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] kbuild: Add "Section mismatch" warning whitelist for powerpc
Thread-Index: AceWL9//RiPvW/3WR+ygXIIjV7qNnAAo2IRA
From: "Li Yang-r58472" <LeoLi@freescale.com>
To: "Kumar Gala" <galak@kernel.crashing.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
Cc: "Linus" <torvalds@linux-foundation.org>, "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Kumar Gala [mailto:galak@kernel.crashing.org]
> Sent: Monday, May 14, 2007 9:57 PM
> To: Sam Ravnborg
> Cc: Li Yang-r58472; Linus; Andrew Morton; Linux Kernel;
linuxppc-dev@ozlabs.org
> Subject: Re: [PATCH 1/2] kbuild: Add "Section mismatch" warning
whitelist for
> powerpc
> 
> 
> On May 14, 2007, at 6:06 AM, Sam Ravnborg wrote:
> 
> > On Mon, May 14, 2007 at 06:53:32PM +0800, Li Yang wrote:
> >> This patch fixes the following "Section mismatch" warnings when
> >> build powerpc platforms.
> >>
> >> -------------
> >> WARNING: arch/powerpc/mm/built-in.o - Section mismatch: reference
to
> >> .init.text:early_get_page from .text between
> >> 'pte_alloc_one_kernel' (at
> >> offset 0xc68) and 'pte_alloc_one'
> >> WARNING: mm/built-in.o - Section mismatch: reference to
> >> .init.text:set_up_list3s from .text between
> >> 'kmem_cache_create' (at offset
> >> 0x20300) and 'cache_reap'
> >> -------------
> 
> This warnings should be handled by __init_refok instead.

Yes.  When __init_refok gets in, we can change all Pattern 9 members in
the whitelist to use __init_refok.

- Leo
