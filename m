Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbZFJJIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbZFJJIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbZFJJIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:08:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56669 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200AbZFJJIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:08:34 -0400
Message-ID: <4A2F780D.3010802@redhat.com>
Date: Wed, 10 Jun 2009 12:08:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Andi Kleen <andi@firstfloor.org>, Marcelo Tosatti <mtosatti@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: MCE: Fix compiling without CONFIG_X86_MCE
References: <1244511444.8361.605.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1244511444.8361.605.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> Enclose do_machine_check with #ifdef CONFIG_X86_MCE.
>
> Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
>
>   

Applied, thanks.

I would have preferred to select X86_MCE instead, but that doesn't do 
anything (need to select X86_MCE_INTEL as well, and that becomes fragile).

-- 
error compiling committee.c: too many arguments to function

