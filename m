Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbZIJIFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbZIJIFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 04:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZIJIFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 04:05:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbZIJIFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 04:05:06 -0400
From: Andreas Schwab <schwab@redhat.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: m86k/m68knommu tree build failure
References: <20090910151137.fb71c103.sfr@canb.auug.org.au>
	<4AA890B5.8000207@snapgear.com>
X-Yow: A wide-eyed, innocent UNICORN, poised delicately in a MEADOW filled with
 LILACS, LOLLIPOPS & small CHILDREN at the HUSH of twilight??
Date: Thu, 10 Sep 2009 10:04:51 +0200
In-Reply-To: <4AA890B5.8000207@snapgear.com> (Greg Ungerer's message of "Thu,
	10 Sep 2009 15:37:57 +1000")
Message-ID: <m363brb4yk.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Ungerer <gerg@snapgear.com> writes:

> Hi Stephen,
>
> Stephen Rothwell wrote:
>> Today's linux-next build (m68k defconfig) failed like this:
>>
>> kernel/built-in.o: In function `ptrace_resume':
>> ptrace.c:(.text+0xc5d6): undefined reference to `user_disable_single_step'
>> ptrace.c:(.text+0xc5fe): undefined reference to `user_enable_single_step'
>> ptrace.c:(.text+0xc620): undefined reference to `user_disable_single_step'
>>
>> Caused by commit 5db612ef70d24be12f6dbf5d06b23bcd6bc2fc05 ("m68knommu:
>> define arch_has_single_step() and friends").  This commit added
>> definitions of these functions for m68knommu, but added declarations (and
>> arch_has_single_step()) in a common header file.
>
> Ah, yes, thanks. I'll fix that. I don't regularly build for m68k,
> so I missed that in my test builds.

An m68k implementation is here
<http://permalink.gmane.org/gmane.linux.ports.m68k/721>.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
