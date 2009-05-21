Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbZEUHhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbZEUHhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 03:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbZEUHhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 03:37:09 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61879 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZEUHhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 03:37:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=m0lLAwSGC9+r+94oqFvxm23kmC512au+U7Dm3nM5a9IkIKN12heMPSSVzpTQMgmx5u
         eEAJTMRA2KbWlrGuMC7HIQmAF70F2OVLWr6xCC9xVK7bg7Kt9dlmXEUKz7+k7N1OEA8V
         Qyu1RJ1LI60KJ+LW9jVrnbbLIcmDifPqxP3kQ=
Message-ID: <4A15049F.8000707@panasas.com>
Date: Thu, 21 May 2009 10:37:03 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>
Subject: Re: linux-next: kvm tree build failure
References: <20090521172122.bb12027c.sfr@canb.auug.org.au> <4A15038B.1090204@redhat.com>
In-Reply-To: <4A15038B.1090204@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2009 10:32 AM, Avi Kivity wrote:
> Stephen Rothwell wrote:
>> Hi Avi,
>>
>> Today's linux-next build (powerpc ppc44x_defconfig) failed like this:
>>
>> arch/powerpc/kvm/built-in.o: In function `kvm_destroy_vm':
>> kvm_main.c:(.text+0x2cfc): undefined reference to `kvm_irqfd_release'
>> arch/powerpc/kvm/built-in.o: In function `kvm_vm_ioctl':
>> kvm_main.c:(.text+0x3230): undefined reference to `kvm_irqfd'
>>
>> Caused by commit 302471ec2b5b6f74eba06973fb85e4584d20ef1e ("KVM: irqfd")
>> which I have reverted for today.
>>   
> 
> Sorry about that.  I now have build testing for s390 and ia64, so of 
> course it triggered on ppc.
> 
> I'll look for a ppc machine for build testing.
> 

Can't you cross compile for ppc? I can't remember someone posted a link
with binary cross-compiler packages a while back.

Boaz

