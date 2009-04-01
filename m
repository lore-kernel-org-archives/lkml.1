Return-Path: <linux-kernel-owner+w=401wt.eu-S934582AbZDAVjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934582AbZDAVjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 17:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758414AbZDAVjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 17:39:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800AbZDAVjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 17:39:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
X-Fcc: ~/Mail/linus
Cc: Arnd Bergmann <arnd@arndb.de>, Will Newton <will.newton@gmail.com>,
       Geert Uytterhoeven <geert.uytterhoeven@gmail.com>,
       michal.simek@petalogix.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
       Chen Liqin <liqin.chen@sunplusct.com>
Subject: Re: [RFC] asm-generic/{unistd,types,posix_types}.h for new arch
In-Reply-To: H. Peter Anvin's message of  Wednesday, 1 April 2009 14:20:58 -0700 <49D3DABA.2050001@zytor.com>
References: <49D071A8.4010703@petalogix.com>
	<200904011611.53355.arnd@arndb.de>
	<87a5b0800904010739g3564eb1fhf32afcfee4936c4b@mail.gmail.com>
	<200904011704.13581.arnd@arndb.de>
	<49D3DABA.2050001@zytor.com>
X-Shopping-List: (1) Periodical delusions
   (2) Impious erosion
   (3) Mythical oligarchical demolition breezes
   (4) Apathetic yies
   (5) Geopolitical scurrilous cheater-hawks
Message-Id: <20090401213219.7B324FC3AB@magilla.sf.frob.com>
Date: Wed,  1 Apr 2009 14:32:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, gcc does have the _LP64 and __SIZEOF_POINTER__ macros (as well 
> as __CHAR_BIT__), although I don't know how far back it does have that. 
>      If it has been with us for long enough it might be possible to 
> switch over to using panarch macros.

Worst case the oldest compilers had <limits.h> and 
"#if ULONG_MAX == 0xffffffffUL", though I wouldn't like
myself to be using a setup where <limits.h> got pulled in.


Thanks,
Roland
