Return-Path: <linux-kernel-owner+w=401wt.eu-S1762605AbXJOJsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762605AbXJOJsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 05:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758235AbXJOJsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 05:48:11 -0400
Received: from il.qumranet.com ([82.166.9.18]:43644 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbXJOJsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 05:48:10 -0400
Message-ID: <47133732.2090809@qumranet.com>
Date: Mon, 15 Oct 2007 11:47:30 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Laurent Vivier <Laurent.Vivier@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND 2][PATCH 4/4] Modify KVM to update guest time	accounting.
References: <46E550EF.5080209@bull.net> <20071015093800.GA22818@elte.hu>
In-Reply-To: <20071015093800.GA22818@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>  int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  
> +/*
> + * Compatibility define - PF_VCPU is only available in v2.6.24+ kernels:
> + */
> +#ifndef PF_VCPU
> +# define PF_VCPU	0
> +#endif
> +
>   

This bit can go; for the external module I can add it back in 
external-module-compat.h.  No need to pollute mainline with backward 
compatibility stuff.


-- 
error compiling committee.c: too many arguments to function

