Return-Path: <linux-kernel-owner+w=401wt.eu-S934117AbZLFT0C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934117AbZLFT0C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 14:26:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbZLFT0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 14:26:01 -0500
Received: from mail.codesourcery.com ([38.113.113.100]:57773 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444AbZLFT0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 14:26:00 -0500
Message-ID: <4B1C0546.5040205@codesourcery.com>
Date: Sun, 06 Dec 2009 22:25:58 +0300
From: Maxim Kuvyrkov <maxim@codesourcery.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: M68k tree updates
References: <alpine.DEB.2.00.0911252213340.31650@ayla.of.borg>
In-Reply-To: <alpine.DEB.2.00.0911252213340.31650@ayla.of.borg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> It took me a while, but finally I managed to update
> http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git again.
> 
> I added the following to master (the main development branch):
...
> I haven't updated m68k-queue (the branch with clean m68k changes w.r.t.
> Linus' tree) yet.
> 
> If anything is missing, please tell me. Thx!

I almost forgot about these two patches:

0001-Define-sigcontext-ABI-of-ColdFire.patch
0002-Fix-m68k-uclinux-s-rt_sigreturn-trampoline.patch

The first patch makes `struct sigcontext' compatible with ColdFire and 
fixes the rt_sigreturn trampoline for ColdFire.  The second patch fixes 
a typo in m68knommu code for rt_sigreturn trampoline.

Both patches are attached to this message 
http://marc.info/?l=linux-m68k&m=125365546306821&w=2 .

I'll appreciate merging these patches to master if it's not too late.

Thanks,

-- 
Maxim Kuvyrkov
CodeSourcery
maxim@codesourcery.com
(650) 331-3385 x724
