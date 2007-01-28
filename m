Return-Path: <linux-kernel-owner+w=401wt.eu-S932175AbXA1NBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbXA1NBT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 08:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932524AbXA1NBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 08:01:19 -0500
Received: from il.qumranet.com ([62.219.232.206]:46846 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175AbXA1NBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 08:01:18 -0500
Message-ID: <45BC9E98.9090103@argo.co.il>
Date: Sun, 28 Jan 2007 15:01:12 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Fix "CONFIG_X86_64_" typo in drivers/kvm/svm.c.
References: <Pine.LNX.4.64.0701251803570.14801@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0701251803570.14801@CPE00045a9c397f-CM001225dbafb6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>   Fix what looks like an obvious typo in the file drivers/kvm/svm.c.
>
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
>
> ---
>
>   is this, in fact, a typo?
>
>   

It is.  Well spotted.

I tested this on my AMD machine, and everything still works.

Acked-by: Avi Kivity <avi@qumranet.com>



> diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
> index 7397bfb..1764fb6 100644
> --- a/drivers/kvm/svm.c
> +++ b/drivers/kvm/svm.c
> @@ -1149,7 +1149,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
>  	case MSR_K6_STAR:
>  		vcpu->svm->vmcb->save.star = data;
>  		break;
> -#ifdef CONFIG_X86_64_
> +#ifdef CONFIG_X86_64
>  	case MSR_LSTAR:
>  		vcpu->svm->vmcb->save.lstar = data;
>  		break;
>
>   


-- 
error compiling committee.c: too many arguments to function

