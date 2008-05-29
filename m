Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbYE2QaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbYE2QaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 12:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbYE2QaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 12:30:10 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45340 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbYE2QaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 12:30:07 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5306"; a="3321775"
Message-ID: <483EDA0D.5020404@qualcomm.com>
Date: Thu, 29 May 2008 09:30:05 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org
Subject: Re: [PATCH] [sched] Move cpu masks from kernel/sched.c into kernel/cpu.c
References: <1211926006-11559-1-git-send-email-maxk@qualcomm.com> <20080528234025.621bce6a.pj@sgi.com>
In-Reply-To: <20080528234025.621bce6a.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max,
> 
> Does this patch mean that some 2K to 3K bytes of kernel text
> will be added to non-SMP systems, due to kernel/cpu.o moving
> from CONFIG_SMP only to always being included?
> 
> If so, then I'd think that the folks who obsess with small
> non-SMP kernels might not like this change.
> 

non-SMP ? Do people still build those :) ?
Just kidding.

Hmm, why would it be any different ?
I've just build UP kernel with and w/o the patch

size vmlinux

before
    text	   data	    bss	    dec	    hex	filename
3313797	 307060	 310352	3931209	 3bfc49	vmlinux

after
    text	   data	    bss	    dec	    hex	filename
3313797	 307060	 310352	3931209	 3bfc49	vmlinux

I think we're good here.

Max
