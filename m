Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbZKWG4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbZKWG4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 01:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZKWG4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 01:56:16 -0500
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:47514 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752297AbZKWG4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 01:56:15 -0500
Message-ID: <4B0A3211.8020104@internode.on.net>
Date: Mon, 23 Nov 2009 17:26:17 +1030
From: indexer <indexer@internode.on.net>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "Tang, Feng" <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 14658] Regression in efi.c
References: <bug-14658-6666@http.bugzilla.kernel.org/> <200911212017.nALKHLSC029634@demeter.kernel.org> <alpine.LFD.2.00.0911221817200.24119@localhost.localdomain> <4B09F685.2080201@internode.on.net> <EADF0A36011179459010BDF5142A457501CFFF3AE2@pdsmsx502.ccr.corp.intel.com>
In-Reply-To: <EADF0A36011179459010BDF5142A457501CFFF3AE2@pdsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tang, Feng wrote:
> Hi William,
>
> One stupid question, when you did the bisect, did you really try to boot every kernel that you built out?
>
> - Feng
>   
>> -----Original Message-----
>> Thomas
>>
>> I had already done a similar bisect to this in private conversation to
>> Huang Ying, and is what prompted me to expand my bisect out. I redid it
>> regardless and will send you the information.
>>
>> commit 74fca6a42863ffacaf7ba6f1936a9f228950f657
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Wed Sep 9 15:13:59 2009 -0700
>>
>>    Linux 2.6.31
>>
>> Makefile |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>>
>> git bisect start
>> # good: [07a2039b8eb0af4ff464efd3dfd95de5c02648c6] Linux 2.6.30
>> git bisect good 07a2039b8eb0af4ff464efd3dfd95de5c02648c6
>> # bad: [74fca6a42863ffacaf7ba6f1936a9f228950f657] Linux 2.6.31
>> git bisect bad 74fca6a42863ffacaf7ba6f1936a9f228950f657
>> # good: [925d74ae717c9a12d3618eb4b36b9fb632e2cef3] V4L/DVB (11736):
>> videobuf: modify return value of VIDIOC_REQBUFS ioctl
>> git bisect good 925d74ae717c9a12d3618eb4b36b9fb632e2cef3
>> # good: [a380137900fca5c79e6daa9500bdb6ea5649188e] ixgbe: Fix device
>> capabilities of 82599 single speed fiber NICs.
>> git bisect good a380137900fca5c79e6daa9500bdb6ea5649188e
>> # good: [b54c3835469c9548d470e7788cb22a2fd7e21133] Merge branch
>> 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
>> git bisect good b54c3835469c9548d470e7788cb22a2fd7e21133
>> # good: [7b2aa037e878c939676675969983284a02958ae3] Merge
>> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6
>> git bisect good 7b2aa037e878c939676675969983284a02958ae3
>> # good: [8486a0f95c844b27ecc855cfec89b7e34f831cad] Merge
>> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
>> git bisect good 8486a0f95c844b27ecc855cfec89b7e34f831cad
>> # good: [f415c413f458837bd0c27086b79aca889f9435e4] Merge
>> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
>> git bisect good f415c413f458837bd0c27086b79aca889f9435e4
>> # good: [37d0892c5a94e208cf863e3b7bac014edee4346d] autofs4 - fix missed
>> case when changing to use struct path
>> git bisect good 37d0892c5a94e208cf863e3b7bac014edee4346d
>> # good: [0edfa2b1b5a5e1475e76dd3c792447687d966de4] Merge branch
>> 'for-linus' of git://oss.sgi.com/xfs/xfs
>> git bisect good 0edfa2b1b5a5e1475e76dd3c792447687d966de4
>> # good: [5136a6c0fd5b26bbf39ad761cf7a4fc563ad83a3] Merge
>> git://git.infradead.org/~dwmw2/mtd-2.6.31
>> git bisect good 5136a6c0fd5b26bbf39ad761cf7a4fc563ad83a3
>> # good: [f69fb9c39868463f6b0b8306824341bd5610250b] Merge branch
>> 'for-linus' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel
>> git bisect good f69fb9c39868463f6b0b8306824341bd5610250b
>> # good: [755ae761c5519929a97567d61a379b87352c337c] Merge branch
>> 'for-linus' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6
>> git bisect good 755ae761c5519929a97567d61a379b87352c337c
>> # good: [7c8460db30dfd085ef3837c8fb02ecf2e718b983] drm/i915: fix mask
>> bits setting
>> git bisect good 7c8460db30dfd085ef3837c8fb02ecf2e718b983
>> # good: [7135a71b19be1faf48b7148d77844d03bc0717d6] aoe: allocate unused
>> request_queue for sysfs
>> git bisect good 7135a71b19be1faf48b7148d77844d03bc0717d6
>> Sincerely
>>
>> William
>>
>> PS - The fact remains i still cant efi boot in 2.6.32-rc7, so this bug
>> still exists, and I will keep doing what i can to help track this down.
>>     
Feng

Yes, i did boot every single on. We had this problem where it was the 
makefile when i did a similar bisect with Huang Ying, and it is what 
prompted me to expand the bisect parameters to v2.6.32. I believe the 
email about that is in the  mailing list still, and im more than happy 
to do any other tests you can think of to test and isolate this bug as 
it currently causes a significant issue.

Cheers

William
