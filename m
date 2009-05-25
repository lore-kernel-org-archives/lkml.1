Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbZEYRlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbZEYRlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 13:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbZEYRlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 13:41:02 -0400
Received: from gecko.sbs.de ([194.138.37.40]:21521 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbZEYRlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 13:41:01 -0400
Message-ID: <4A1AD816.1060702@siemens.com>
Date: Mon, 25 May 2009 19:40:38 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Huang Ying <ying.huang@intel.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] KVM: MCE: Add MCE support to KVM
References: <1242031695.8213.17.camel@yhuang-dev.sh.intel.com> <4A105DE2.8090200@redhat.com>
In-Reply-To: <4A105DE2.8090200@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Huang Ying wrote:
>> The related MSRs are emulated. MCE capability is exported via
>> extension KVM_CAP_MCE and ioctl KVM_X86_GET_MCE_CAP_SUPPORTED.  A new
>> vcpu ioctl command KVM_X86_SETUP_MCE is used to setup MCE emulation
>> such as the mcg_cap. MCE is injected via vcpu ioctl command
>> KVM_X86_SET_MCE. Extended machine-check state (MCG_EXT_P) and CMCI are
>> not implemented.
>>
>>   
> 
> Applied, thanks.
> 

This patch breaks kvm build for 32-bit hosts.

Is the KVM MCE interface completely or only partially limited to x86-64,
ie. can I completely #ifdef it away on 32-bit hosts (including
KVM_CAP_MCE) or is this more complicated?

Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
