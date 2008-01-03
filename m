Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYACOCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYACOCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 09:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYACOCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 09:02:06 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:15434 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751006AbYACOCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 09:02:05 -0500
Message-ID: <477CEAAB.4030200@panasas.com>
Date: Thu, 03 Jan 2008 16:01:15 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Christoph Hellwig <hch@infradead.org>, schwidefsky@de.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 2/3] CONFIG_HIGHPTE vs. sub-page page tables.
References: <20071112143009.425807965@de.ibm.com> <20071112144009.831296895@de.ibm.com> <20080102204435.GB15460@infradead.org> <200801031412.26806.ak@suse.de>
In-Reply-To: <200801031412.26806.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jan 2008 14:01:18.0196 (UTC) FILETIME=[1CA3B340:01C84E11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03 2008 at 15:12 +0200, Andi Kleen <ak@suse.de> wrote:
>> Can we please just nuke CONFIG_HIGHPTE?  There's only been a small
>> amount of 32bit machines 
> 
> It's unfortunately a larger amount :/ And for unknown reasons a lot of
> people still install 32bit kernels on new perfectly capable 64bit systems
> even if they have a lot of memory.
> 
Yes I've seen that too many times. When I comment about it, people say:
"What this 'core 2' supports AMD64 ??!!"

I think this is the distros fault.
1. Most call it AMD64 and not, i don't know what it should be called.

2. They put the first and default installation as i386 and not the x64,
   the later is only farther down or on a different link.

3. My Fedora x86_64 installation has a full blown 32bit installation inside.
   In fact, every time I yum install this or that, I get installed by default
   both the 64bit and 32bit libraries. I don't even know how to turn the 32bit
   off. This means that Distros can supply one x86 installation for both
   flavors and decide at setup time what to install. By this, follow the Kernel
   in observing that it is the same-ARCH same-INSTALL.

4. Some binary modules like Flash, media-codecs acrobat-reader etc... think
   (That snow ball effect here) that 32bit is much more common and only provide
   that. So people think that for best compatibility they should stick with 
   32bit. But this is not true. They all work perfectly here in 64bit land.
   Distros should both confirm on that publicly. And also make extensive tests 
   for 32bit compatibility on 64bit machines, even for these binary only bad
   guys.

5. Distros should jump on the 64bit bang-wagon, to stand it-self apart from
   Window 32bit-ness. It has bin proven more than once that a Huge Linux 64bit 
   machine, with lots of CPUs and memory, can be the best Windows 32bit performer 
   in existence. Both under KVM/VMWARE or Wine. 64bit Vista can never get close,
   not to speak of the "none-existent" 64bit XP.

Just my $0.02
Boaz

> I don't think removing CONFIG_HIGHPTE will be an option any time soon.
> 
> -Andi
> --

