Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbZAUT45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbZAUT45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 14:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbZAUT4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 14:56:48 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:18334 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZAUT4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 14:56:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PoJsedmPUWIyc/wxsI5M26kZ65rt30E2Vur8dxIHStjaMSVNWr54cXwpFtevUMzox/
         5Hg+ekOLpV330tR34vnZz8igLJlt8zN6TgvoMpJcB+t62GLoJWYp9xdNoiiDeVMwDx0L
         Y9g35eqTbJ42m2FwgmtDIdIFTf9r8202zz6IA=
Message-ID: <49777DF5.1080107@gmail.com>
Date: Wed, 21 Jan 2009 20:56:37 +0100
From: Uros Bizjak <ubizjak@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: Unneeded assignment to tsk in recent x86 change
References: <5787cf470901210432l5327e48el94c53c8fb7fd6d1d@mail.gmail.com> <18807.7643.368198.582428@harpo.it.uu.se>
In-Reply-To: <18807.7643.368198.582428@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:

>  > Impact: Cleanup.
>  > 
>  > Remove unneeded assignment to tsk in recent x86 change [1].
>  
>
>  > @@ -795,13 +794,12 @@ asmlinkage
>  >  void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  >  {
>  >  	unsigned long address;
>  > -	struct task_struct *tsk;
>  > +	struct task_struct *tsk = current;
>  >  	struct mm_struct *mm;
>  >  	struct vm_area_struct *vma;
>  >  	int write;
>  >  	int fault;
>  >  
>  > -	tsk = current;
>  >  	mm = tsk->mm;
>  >  	prefetchw(&mm->mmap_sem);
>
> but this is neither a fix nor IMO a cleanup (it's inconsistent with
> the other variables in that function)
>   

Hm, I'm not sure I see the inconsistency here. Care to explain this 
inconsistency in a couple of words?

Thanks,
Uros.

