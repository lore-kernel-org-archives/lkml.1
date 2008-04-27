Return-Path: <linux-kernel-owner+w=401wt.eu-S1761046AbYD0Qhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761046AbYD0Qhd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 12:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbYD0QhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 12:37:25 -0400
Received: from outbound-mail-128.bluehost.com ([67.222.38.28]:57893 "HELO
	outbound-mail-128.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752946AbYD0QhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 12:37:25 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] "big box" x86 changes, PCI
Date: Sun, 27 Apr 2008 09:30:55 -0700
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>
References: <20080426185516.GA32364@elte.hu> <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org> <20080426215540.GA3545@elte.hu>
In-Reply-To: <20080426215540.GA3545@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804270930.55647.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, April 26, 2008 2:55 pm Ingo Molnar wrote:
> ok, this is the final chunk of the "big box" topic - the PCI changes.
>
> These are the largest, and while i tried to reduce their number it's
> still 19 commits - but it's all around the same topic. The bulk of the
> new code is in a single file. The tree can be pulled from:
>
>   
> git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-bigbox-pci.
>git for-linus
>
> this depends on the bootmem changes which are now upstream. These
> changes too have been in linux-next for some time and the cross-arch
> (build) success rate is high, as in:
>
>    http://www.tglx.de/autoqa-cgi/index?run=89&tree=1
>
> all but the last few patches have been in x86.git for a longer time and
> more than 95% of the changes are for arch/x86. (see the dates of the
> patches. The "15 Feb 2008" ones are older than their timestamp - that's
> when we imported those changes into a date-aware repository.)
>
> i booted up this tree 5 times on x86, mixed 64-bit/32-bit.

Only did a quick scan, but the changes look nice so far.  I'll take a closer 
look and give it a try locally tomorrow.

On an unrelated note, can you take a look at the "PCI MSI breaks when booting 
with nosmp" thread?  I posted a patch there that unconditionally enables the 
local apic with nosmp/maxcpus=0 so that MSI will work correctly.  The other 
option of course is to disable MSI when nosmp/maxcpus=0 and local apic enable 
code alone.

Thanks,
Jesse
