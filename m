Return-Path: <linux-kernel-owner+w=401wt.eu-S1751953AbZHFBnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbZHFBnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 21:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZHFBnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 21:43:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50418 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZHFBnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 21:43:22 -0400
Message-ID: <4A7A35A0.4040707@redhat.com>
Date: Thu, 06 Aug 2009 09:45:04 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Neil Horman <nhorman@redhat.com>
CC: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 2/7] x86: implement crashkernel=auto
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain> <20090805112142.6552.18373.sendpatchset@localhost.localdomain> <20090805134342.GE7259@hmsreliant.think-freely.org>
In-Reply-To: <20090805134342.GE7259@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> What about all the other arches that support kexec?  ia64/ppc[64]/s390/etc?
> Don't they need an implementation of arch_default_crash_size?  Or perhaps better
> still you should put this definition in asm-generic, so that it can be
> overridden per-arch if need be, but you always have something to fall back on.
>   

Hmm, I think you mean we need ARCH_HAS_XXXX....
OK, it is a good idea, I will try it.

Thanks for your review, Neil.

