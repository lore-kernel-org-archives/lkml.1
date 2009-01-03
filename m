Return-Path: <linux-kernel-owner+w=401wt.eu-S1759613AbZACHVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613AbZACHVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 02:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZACHVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 02:21:07 -0500
Received: from ozlabs.org ([203.10.76.45]:44230 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZACHVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 02:21:05 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PULL] cpumask tree
Date: Sat, 3 Jan 2009 17:50:59 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu>
In-Reply-To: <20090102203839.GA26850@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901031751.00076.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009 07:08:40 Ingo Molnar wrote:
>  - architectures that have no __fls (8 out of 21) fail to build:
> 
>      arch/cris
>      arch/frv
>      arch/h8300
>      arch/m32r
>      arch/m68k
>      arch/mn10300
>      arch/xtensa

Fixes pushed, m68k should be OK tho; is this actual compile test?  You have
to look in include/asm-m68k to see __fls.

> Rusty, would it be fine with you if we did all the remaining bits via 
> tip/cpus4096? It's your tree and your bits and we wanted to send our 
> remaining bits after your tree went to Linus but the conflict resolutions 
> from Mike are valuable so i think we should reconsider the ordering.

Yeah, no reason for us to do the merge twice.  As long as it ends upstream,
I'm a happy camper.

Thanks,
Rusty.
