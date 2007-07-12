Return-Path: <linux-kernel-owner+w=401wt.eu-S935204AbXGLCmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935204AbXGLCmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 22:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932415AbXGLCmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 22:42:14 -0400
Received: from gw.goop.org ([64.81.55.164]:59636 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757587AbXGLCmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 22:42:13 -0400
Message-ID: <469594CB.8090705@goop.org>
Date: Wed, 11 Jul 2007 19:41:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] Add /sys/kernel/notes
References: <20070712004249.A59D84D0555@magilla.localdomain>
In-Reply-To: <20070712004249.A59D84D0555@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> The earlier patches in this series change the linker script to place it
> appropriately and set the phdr.  It's allocated when its input sections are
> allocated.  Current builds I've seen don't have any input note sections at
> all.  My motivation is for the ld --build-id support, which generates an
> allocated note section as if it were input.
>   

OK, I see.

>> I have a patch to always do this, and also convert all the note 
>> generation to C code rather than asm.  If your patch works for you, 
>> however, it should be completely orthogonal.
>>     
>
> What note generation do you mean?  The only explicit notes in asm that I
> know of are in the vDSO images, not in vmlinux.  This patch has nothing to
> do with any vDSO image's generation.
>   

I'm adding other notes for Xen, so I have some in my tree.  But the vdso 
ones could also be generated in C rather than asm.   I'm not sure what 
stage the patch to convert vsyscall-notes to using linux/elfnote.h is 
at; I think its in Andi's tree.

    J
