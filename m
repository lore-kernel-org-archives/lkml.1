Return-Path: <linux-kernel-owner+w=401wt.eu-S1765460AbYHHWN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765460AbYHHWN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764080AbYHHWCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:02:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34684 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764073AbYHHWCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:02:17 -0400
Message-ID: <489CC246.5000202@zytor.com>
Date: Fri, 08 Aug 2008 15:01:42 -0700
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
> Please check dyn_array support for x86
> v3: split changing to nr_irqs to small patches
>    fix checkpatch error
>    reorder the patch sequence to make dyn_array support go at first
>        so could use that with arrays other than NR_IRQS
> v4: add CONFIG_HAVE_SPARSE_IRQ with list to use condensed irq_desc array
>    so could use 32 init, and init more if needed.
>    x86 32bit: have CONFIG_HAVE_DYN_ARRAY
>    x86 64bit: have CONFIG_HAVE_DYN_ARRAY and CONFIG_HAVE_SPARSE_IRQ
> 

So I'm still clearly missing something about this... if we need sparse 
IRQs in the first place (which we do), what's the point of the dyn_array?

	-hpa
