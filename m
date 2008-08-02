Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbYHBC6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbYHBC6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 22:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYHBC6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 22:58:05 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:21324 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbYHBC6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 22:58:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vedQVqPTpVAITsuVsPndCnE8UToFna7NuRJrZJq7DDjsauHz5Ouh2IDxeE2Qln22P4
         a8IsClKbyXJzgslPlxzufb7saE//6sidpsZpb+nDZysjRXdiYWqk+5QlS1zzBO1KNSB+
         yjbPrrBr15CAJ/UTjgfFN7S13h/w7aEEktnPw=
Message-ID: <86802c440808011958v73e6b9a9y19a034b63b9d2986@mail.gmail.com>
Date: Fri, 1 Aug 2008 19:58:02 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1iqukwjjg.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
	 <m1iqukwjjg.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2008 at 1:46 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> My core concerns are:
> - The generic code has no business with dealing with NR_IRQS sized arrays.
>  Since we don't have a generic problem I don't see why we should have a generic dyn_array solution.

there is some NR_IRQS arrays are left over and not put into PER_CPU?

Wonder if could use dyn_array with some of them.

YH
