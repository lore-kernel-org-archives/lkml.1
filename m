Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbZDMVXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbZDMVXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbZDMVXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:23:38 -0400
Received: from gw.goop.org ([64.81.55.164]:49665 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbZDMVXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:23:38 -0400
Message-ID: <49E3AD58.2020700@goop.org>
Date: Mon, 13 Apr 2009 14:23:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Xen bugfixes for -rc1
References: <49E385FE.8050902@goop.org> <20090413203518.GC19972@elte.hu>
In-Reply-To: <20090413203518.GC19972@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> I've pulled it into x86/urgent as well, thanks.
>
> This is a strict subset of the Xen tree i sent to Linus to earlier, 
> right?
>
> The two places where there seems to have been some rebasing 
> complexity is arch/x86/include/asm/required-features.h and 
> arch/x86/xen/mmu.c.
>   

Yes, its just the core change without the /sys/hypervisor and 
/dev/xen/evtchn drivers.  The only difference is rebasing it off the 
lazy mmu update preemption changes, which affected xen/mmu.c.  The 
required-features.h change is because 5f241e65 is not yet in mainline 
(but probably should be).

    J
