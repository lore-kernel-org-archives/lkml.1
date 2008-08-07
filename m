Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbYHGSQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbYHGSQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYHGSQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:16:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52931 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbYHGSQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:16:30 -0400
Message-ID: <489B3B01.9080209@zytor.com>
Date: Thu, 07 Aug 2008 11:12:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/33] dyn_array and nr_irqs support v4
References: <1218011937-10084-1-git-send-email-yhlu.kernel@gmail.com>	 <m1hc9yjb7x.fsf@frodo.ebiederm.org>	 <86802c440808061129l2bbe1658w453a11b4f16ffc83@mail.gmail.com>	 <m1y739j2z8.fsf@frodo.ebiederm.org>	 <20080807002638.04699eac@lxorguk.ukuu.org.uk>	 <m18wv9iqn9.fsf@frodo.ebiederm.org>	 <20080807111216.6cfdbeea@lxorguk.ukuu.org.uk> <86802c440808070351m6400b290jb826d10407c7de77@mail.gmail.com>
In-Reply-To: <86802c440808070351m6400b290jb826d10407c7de77@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> #ifndef CONFIG_HAVE_SPARSE_IRQ
> #define   valid_irq(irq)          ((irq) > 0 && (irq) < nr_irqs)
> #else
> #define   valid_irq(irq)          ((irq) > 0)
> 
> anyway why 0 is invalid instead of -1U...?
> 

Because 0 is easier to understand to a user when specifying in a module 
option.

	-hpa
