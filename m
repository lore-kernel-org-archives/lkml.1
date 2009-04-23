Return-Path: <linux-kernel-owner+w=401wt.eu-S1752465AbZDWBwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbZDWBwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 21:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZDWBvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 21:51:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33592 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbZDWBvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 21:51:54 -0400
Message-ID: <49EFC8FE.7010403@zytor.com>
Date: Wed, 22 Apr 2009 18:48:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Joe Damato <ice799@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org
Subject: Re: [PATCH] X86-32: Let gcc decide whether to inline memcpy was Re:
 	New x86 warning
References: <49EEBD3C.3060009@garzik.org> <20090422070157.GA28438@elte.hu>	 <8763gxoz50.fsf_-_@basil.nowhere.org> <3605561d0904221649n169dc579xb0694297154d97fa@mail.gmail.com>
In-Reply-To: <3605561d0904221649n169dc579xb0694297154d97fa@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Damato wrote:
> 
> I think this patch is great. Perhaps this would be a good time to also
> clean out memset for x86_32? (If needed, I can start a new email
> thread with this patch) I've built and booted this on my x86_32
> hardware.
> 

Under the same conditions, i.e. making sure that with the oldest gcc we
still care about (3.2) we don't end up uninlining any new cases we
shouldn't.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

