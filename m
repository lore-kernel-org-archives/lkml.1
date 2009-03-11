Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbZCKWok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbZCKWok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbZCKWob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 18:44:31 -0400
Received: from ozlabs.org ([203.10.76.45]:32806 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbZCKWob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 18:44:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tony Luck <tony.luck@gmail.com>
Subject: Re: [PATCH 06/10] percpu: kill percpu_alloc() and friends
Date: Thu, 12 Mar 2009 09:14:22 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <1234958676-27618-7-git-send-email-tj@kernel.org> <12c511ca0903111136h3805a106i484a32fd2972c568@mail.gmail.com>
In-Reply-To: <12c511ca0903111136h3805a106i484a32fd2972c568@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903120914.23199.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009 05:06:58 Tony Luck wrote:
>          wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
> 
> and the cpu_workqueue_struct is defined as ____cacheline_aligned

Yes, and it no longer needs to be now we have the real per-cpu allocator.

Thanks,
Rusty.
