Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZJLLU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZJLLU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 07:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbZJLLU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 07:20:58 -0400
Received: from er-systems.de ([85.25.136.202]:52891 "EHLO er-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbZJLLU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 07:20:57 -0400
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Oct 2009 07:20:57 EDT
Date: Mon, 12 Oct 2009 13:09:56 +0200 (CEST)
From: Thomas Voegtle <tv@lio96.de>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/26] 2.6.31.4-stable review
In-Reply-To: <20091009233812.GA15982@kroah.com>
Message-ID: <alpine.LNX.2.00.0910121304460.10773@er-systems.de>
References: <20091009231249.GA31084@kroah.com> <20091009233812.GA15982@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Virus-Checker-Version: clamassassin 1.2.4 with clamdscan / ClamAV 0.95.2/9882/Mon Oct 12 05:15:10 2009 signatures .
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009, Greg KH wrote:

> On Fri, Oct 09, 2009 at 04:12:49PM -0700, Greg KH wrote:
>> This is the start of the stable review cycle for the 2.6.31.4 release.
>> There are 26 patches in this series, all will be posted as a response to
>> this one.  If anyone has any issues with these being applied, please let
>> us know.  If anyone is a maintainer of the proper subsystem, and wants
>> to add a Signed-off-by: line to the patch, please respond with it.
>
> Oops, a bunch of network patches came in right when this went out, and I
> don't want to have to wait to get them on, so I've rolled a -rc2 version
> now.
>
> There's now 37 patches in this series, I'll attach the rest to this
> thread now.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.31.4-rc2.gz
> and the diffstat can be found below.


This ends up for me in:

   CC      arch/x86/kernel/init_task.o
   LDS     arch/x86/kernel/vmlinux.lds
   CC [M]  arch/x86/kernel/msr.o
   CC [M]  arch/x86/kernel/cpuid.o
   CC [M]  arch/x86/kernel/microcode_core.o
   CC [M]  arch/x86/kernel/microcode_intel.o
   CC [M]  arch/x86/kernel/microcode_amd.o
   LD [M]  arch/x86/kernel/microcode.o
   LD      arch/x86/kvm/built-in.o
   CC [M]  arch/x86/kvm/svm.o
arch/x86/kvm/svm.c: In function 'svm_vcpu_load':
arch/x86/kvm/svm.c:713: error: 'struct vcpu_svm' has no member named 
'nested'
make[2]: *** [arch/x86/kvm/svm.o] Error 1
make[1]: *** [arch/x86/kvm] Error 2
make: *** [arch/x86] Error 2


CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m

gcc version 4.2.4

using kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.31.4-rc2.gz

