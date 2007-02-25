Return-Path: <linux-kernel-owner+w=401wt.eu-S1752344AbXBYQeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbXBYQeJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 11:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbXBYQeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 11:34:09 -0500
Received: from vms046pub.verizon.net ([206.46.252.46]:42232 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbXBYQeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 11:34:08 -0500
Date: Sun, 25 Feb 2007 11:33:52 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: 2.6.20-ck1
In-reply-to: <200702252132.15145.kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Cc: Con Kolivas <kernel@kolivas.org>, ck mailing list <ck@vds.kolivas.org>
Message-id: <200702251133.53117.gene.heskett@gmail.com>
Organization: very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200702162110.03355.kernel@kolivas.org>
 <200702242334.31864.gene.heskett@gmail.com>
 <200702252132.15145.kernel@kolivas.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 February 2007, Con Kolivas wrote:
>On Sunday 25 February 2007 15:34, Gene Heskett wrote:
>> I have a problem, Con.  The patch itself works fine for me, BUT it
[...]
>> Can we have a patch to address this?  Or should I just hardcode it
>> since it will never be linked to any other later kernel?
>>
>> I tried that in the src tree's include/linux/version.h, but it was
>> refreshed back to the original regex code by the make, so that's not
>> where to do it obviously.  I've also made the simlink in /usr/src, but
>> since a kernel make re-writes version.h, that didn't help.
>>
>> Whats next?
>
>I've never heard of this problem before. As far as I'm aware the
> EXTRAVERSION usually is not included in version.h so it seems to be a
> limitation of the flgrx installer? That would mean the flgrx installer
> wouldn't work on any kernel with an extra version such as the -rc
> releases of mainline even. So I'm sorry but I don't really know what to
> do about this problem.

Well, fwiw, I rebooted to 2.6.20 after looking at the error message again, 
and I didn't expect it to work, and it didn't.  Attempting to build it 
from a console before I ever startx'd, the error message is that the 
modules are versioned as "" where the kernel is "2.6.20".
========================================
[Message] Kernel Module : Trying to install a precompiled kernel module.
[Message] Kernel Module : Precompiled kernel module version mismatched.
[Message] Kernel Module : Found kernel module build environment, 
generating kernel module now.
ATI module generator V 2.0
==========================
initializing...
Error:
kernel includes at /lib/modules/2.6.20/build/include do not match current 
kernel.
they are versioned as ""
instead of "2.6.20".
you might need to adjust your symlinks:
- /usr/include
- /usr/src/linux
[Error] Kernel Module : Failed to compile kernel module - please consult 
readme.
=======================
Modules versioning is enabled in the build .config:

[root@coyote linux-2.6.20]# grep VERSION .config
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y

So it appears the installer simply isn't capable of finding the modinfo at 
all.

So much for ati's linux support, they can't even throw working code over 
the fence.  I've ordered an nvidia 6800 card for the next round of 
testing.  2+ years of screwing around with a garden slug speed video is 
enough.

Thanks for the reply Con, I appreciate it.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
