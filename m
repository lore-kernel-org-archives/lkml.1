Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbZEUHcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbZEUHcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 03:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbZEUHcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 03:32:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43867 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbZEUHci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 03:32:38 -0400
Message-ID: <4A15038B.1090204@redhat.com>
Date: Thu, 21 May 2009 10:32:27 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: linux-next: kvm tree build failure
References: <20090521172122.bb12027c.sfr@canb.auug.org.au>
In-Reply-To: <20090521172122.bb12027c.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Avi,
>
> Today's linux-next build (powerpc ppc44x_defconfig) failed like this:
>
> arch/powerpc/kvm/built-in.o: In function `kvm_destroy_vm':
> kvm_main.c:(.text+0x2cfc): undefined reference to `kvm_irqfd_release'
> arch/powerpc/kvm/built-in.o: In function `kvm_vm_ioctl':
> kvm_main.c:(.text+0x3230): undefined reference to `kvm_irqfd'
>
> Caused by commit 302471ec2b5b6f74eba06973fb85e4584d20ef1e ("KVM: irqfd")
> which I have reverted for today.
>   

Sorry about that.  I now have build testing for s390 and ia64, so of 
course it triggered on ppc.

I'll look for a ppc machine for build testing.

-- 
error compiling committee.c: too many arguments to function

