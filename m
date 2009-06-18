Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbZFRJtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbZFRJtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 05:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbZFRJtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 05:49:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55159 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbZFRJto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 05:49:44 -0400
Message-ID: <4A3A0D94.4000803@redhat.com>
Date: Thu, 18 Jun 2009 12:49:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>
Subject: Re: linux-next: kvm tree build failure
References: <20090618111120.9c226ab7.sfr@canb.auug.org.au> <1245299157.2871.1.camel@ht.satnam>
In-Reply-To: <1245299157.2871.1.camel@ht.satnam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2009 07:25 AM, Jaswinder Singh Rajput wrote:
> [PATCH] KVM: use MSR_K7_HWCR for MSRC001_0015 Hardware Configuration Register (HWCR)
>
> MSR_K8_MSR is removed as it is duplicating MSRC001_0015 Hardware
> Configuration Register (HWCR), which is already defined as MSR_K7_HWCR
>
> Fix x86_64 allmodconfig :
>
> arch/x86/kvm/svm.c: In function 'svm_set_msr':
> arch/x86/kvm/svm.c:2152: error: 'MSR_K8_HWCR' undeclared (first use in this function)
>
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

