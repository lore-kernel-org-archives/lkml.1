Return-Path: <linux-kernel-owner+w=401wt.eu-S1759228AbYAYVdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228AbYAYVdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYAYVcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:32:51 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:22071 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbYAYVcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:32:51 -0500
Message-ID: <479A5589.7030201@codemonkey.ws>
Date: Fri, 25 Jan 2008 15:32:57 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH][RFC] SVM: Add Support for Nested Paging in
 AMD Fam16 CPUs
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Hi,                                                                                                                              
>
> here is the first release of patches for KVM to support the Nested Paging (NPT)
> feature of AMD QuadCore CPUs for comments and public testing. This feature
> improves the guest performance significantly. I measured an improvement of
> around 17% using kernbench in my first tests.
>
> This patch series is basically tested with Linux guests (32 bit legacy
> paging, 32 bit PAE paging and 64 bit Long Mode). Also tested with Windows Vista
> 32 bit and 64 bit. All these guests ran successfully with these patches. The
> patch series only enables NPT for 64 bit Linux hosts at the moment.
>
> Please give these patches a good and deep testing. I hope we have this patchset
> ready for merging soon.
>   

A quick sniff test and things look pretty good.  I was able to start 
running the install CDs for 32-bit and 64-bit Ubuntu, 32-bit OpenSuSE, 
64-bit Fedora, and 32-bit Win2k8.  I'll do a more thorough run of 
kvm-test on Monday when I have a better connection to my machine.

Nice work!

Regards,

Anthony Liguori

> Joerg
>
> Here is the diffstat:
>
>  arch/x86/kvm/mmu.c         |   81 +++++++++++++++++++++++++++++++++++---
>  arch/x86/kvm/mmu.h         |    6 +++
>  arch/x86/kvm/svm.c         |   94 +++++++++++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/vmx.c         |    7 +++
>  arch/x86/kvm/x86.c         |    1 +
>  include/asm-x86/kvm_host.h |    4 ++
>  6 files changed, 182 insertions(+), 11 deletions(-)
>
>
>
>
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2008.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> kvm-devel mailing list
> kvm-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/kvm-devel
>   

