Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbZDVWBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbZDVWBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 18:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbZDVWA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 18:00:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42516 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbZDVWA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 18:00:57 -0400
Date: Thu, 23 Apr 2009 00:04:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH] X86-32: Let gcc decide whether to inline memcpy was Re: New x86 warning
Message-ID: <20090422220428.GE13896@one.firstfloor.org>
References: <49EEBD3C.3060009@garzik.org> <20090422070157.GA28438@elte.hu> <8763gxoz50.fsf_-_@basil.nowhere.org> <alpine.LFD.2.00.0904221354320.3101@localhost.localdomain> <20090422211501.GD13896@one.firstfloor.org> <alpine.LFD.2.00.0904221417110.3101@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904221417110.3101@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Quick test here:
> 
> How about you just compile the kernel with gcc-3.2 and compare the number 
> of calls to memcpy before-and-after instead? That's the real test.

I waited over 10 minutes for the full vmlinux objdumps to finish. sorry lost
patience. If someone has a fast disassembler we can try it. I'll leave
them running over night, maybe there are exact numbers tomorrow.

But from a quick check (find -name '*.o' | xargs nm | grep memcpy) there are
very little files which call it with the patch, so there's some
evidence that there isn't a dramatic increase.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
