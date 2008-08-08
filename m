Return-Path: <linux-kernel-owner+w=401wt.eu-S1763606AbYHHWUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763606AbYHHWUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761393AbYHHWUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:20:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53008 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760807AbYHHWUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:20:23 -0400
Message-ID: <489CC684.8060607@zytor.com>
Date: Fri, 08 Aug 2008 15:19:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/42] dyn_array/nr_irqs/sparse_irq support v5
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
In-Reply-To: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> based on tip/master
> 
> to do:
>    so dyn irq_desc is done, and ready to:
>    make create_irq to get irq according to bus/dev/func/vector
> 

Hm... I tried to check this in as a separate topic branch, but it 
conflicts against both linus and against tip:x86/core, which are the 
branches we usually base topic branches on.

I really am not convinced about the whole dyn_array concept, and 
*especially* not having divergences between 32 and 64 bits with regards 
to sparse IRQs.  Furthermore, there are a number of checkpatch errors 
for this patch series, most of which appear legit.

So again... any reason to not just have sparse IRQs and be done with it?

	-hpa

