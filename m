Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbYHVJIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbYHVJIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 05:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYHVJII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 05:08:08 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:63009 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbYHVJIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 05:08:06 -0400
X-IronPort-AV: E=Sophos;i="4.32,251,1217822400"; 
   d="scan'208";a="16918316"
Message-ID: <48AE81B9.4070103@citrix.com>
Date: Fri, 22 Aug 2008 10:07:05 +0100
From: Alex Nixon <alex.nixon@citrix.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix probe_nr_irqs for xen
References: <1219349409-15698-1-git-send-email-yhlu.kernel@gmail.com> <48ADFB33.8010204@goop.org> <20080822042831.GB15212@elte.hu>
In-Reply-To: <20080822042831.GB15212@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Aug 2008 09:08:05.0779 (UTC) FILETIME=[9693E630:01C90436]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
>> Yinghai Lu wrote:
>>> otherwise Xen is _completely_ unusable with 5 or more VCPUs.
>>> ( when !CONFIG_HAVE_SPARSE_IRQ)
>>>
>>> based on Alex's patch
>>>
>>> also add +1 offset after redir_entries
>>>
>>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>> Cc: Alex Nixon <alex.nixon@citrix.com>
>>>   
>> Looks good to me.  We can fix this in a better way later.
>>
>> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> applied to tip/irq/sparseirq. 
> 
> Alex, does this approach work for you too?
> 
> 	Ingo

Yep.

- Alex
