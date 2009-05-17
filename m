Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbZEQS44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbZEQS44 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 14:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZEQS4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 14:56:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53098 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbZEQS4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 14:56:41 -0400
Message-ID: <4A105DE2.8090200@redhat.com>
Date: Sun, 17 May 2009 21:56:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] KVM: MCE: Add MCE support to KVM
References: <1242031695.8213.17.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1242031695.8213.17.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> The related MSRs are emulated. MCE capability is exported via
> extension KVM_CAP_MCE and ioctl KVM_X86_GET_MCE_CAP_SUPPORTED.  A new
> vcpu ioctl command KVM_X86_SETUP_MCE is used to setup MCE emulation
> such as the mcg_cap. MCE is injected via vcpu ioctl command
> KVM_X86_SET_MCE. Extended machine-check state (MCG_EXT_P) and CMCI are
> not implemented.
>
>   

Applied, thanks.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

