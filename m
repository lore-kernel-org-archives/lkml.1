Return-Path: <linux-kernel-owner+w=401wt.eu-S933861AbXK2WgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933861AbXK2WgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759895AbXK2Wf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:35:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45195 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754965AbXK2Wfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:35:55 -0500
Date: Thu, 29 Nov 2007 14:34:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 6/6] x86-64 ia32 ptrace get/putreg32 current
 task
In-Reply-To: <20071129222531.EFEA826F8E7@magilla.localdomain>
Message-ID: <alpine.LFD.0.9999.0711291434270.8458@woody.linux-foundation.org>
References: <20071129003849.428E026F8E7@magilla.localdomain> <20071129004222.E49AD26F8E7@magilla.localdomain> <474EF824.3020806@redhat.com> <alpine.LFD.0.9999.0711290958110.8458@woody.linux-foundation.org> <20071129222531.EFEA826F8E7@magilla.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Nov 2007, Roland McGrath wrote:
> 
> Um, really?  This is x86-64 code.  AIUI those values don't have any effect
> at all in 64-bit mode (as the kernel is).  I haven't found any code in
> entry_64.S or ia32entry.S that touches them.  __switch_to uses direct
> access to the segment registers just as I've done.

Yes, you're right, I just looked at the ia32 part and didn't read your 
patches right.

		Linus
