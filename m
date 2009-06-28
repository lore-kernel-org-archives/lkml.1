Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbZF1Hjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbZF1Hjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 03:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZF1Hj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 03:39:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38417 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbZF1Hj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 03:39:28 -0400
Message-ID: <4A471E7F.2040907@redhat.com>
Date: Sun, 28 Jun 2009 10:40:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Christian_Borntr=E4ger?= <christian@borntraeger.net>
Subject: Re: [PATCH linux-next] kvm/powerpc: fix kvm build tree failure
References: <20090626152347.f87cfa4f.sfr@canb.auug.org.au>
In-Reply-To: <20090626152347.f87cfa4f.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2009 08:23 AM, Stephen Rothwell wrote:
> Today's linux-next build (powerpc ppc44x_defconfig) failed like this:
>
> In file included from include/trace/events/kvm.h:57,
>                   from arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:63:
> include/trace/define_trace.h:53:43: error: trace/events/TRACE_SYSTEM.h: No such file or directory
>
> Caused by commit faa113b7c65c44ed94ac06f6bae2259290040856 ("KVM:
> Protect irq tracing with KVM_HAVE_IOAPIC and KVM_HAVE_PIT").
>
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

