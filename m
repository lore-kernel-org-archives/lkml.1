Return-Path: <linux-kernel-owner+w=401wt.eu-S1761684AbYHEX1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761684AbYHEX1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 19:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756454AbYHEX04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 19:26:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42483 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYHEX0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 19:26:55 -0400
Message-ID: <4898E1B4.60101@zytor.com>
Date: Tue, 05 Aug 2008 16:26:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/25] dyn_array and nr_irqs support v3
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>	 <4898DBD8.4000002@zytor.com> <86802c440808051615h57baa06ci5ab040048786b50d@mail.gmail.com>
In-Reply-To: <86802c440808051615h57baa06ci5ab040048786b50d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> i am working on dyn_array + condense irq_desc/irq_cfg.
> 
> it will use dyn_array to allocate 32 entry for irq_desc/irq_cfg, and
> will use get_irq_desc via list to distribute it. later if need more,
> will allocate more 32 entries....
> 
> so will send out v4.
> 

My understanding of dyn_array is that it only works at init time.  How 
does that work when you hotplug MSI-X devices?

	-hpa
