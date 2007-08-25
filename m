Return-Path: <linux-kernel-owner+w=401wt.eu-S1765090AbXHYRdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765090AbXHYRdZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 13:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbXHYRdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 13:33:17 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:34147 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbXHYRdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 13:33:17 -0400
Date: Sat, 25 Aug 2007 21:34:33 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: taoyue <yue.tao@windriver.com>, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] sigqueue_free: fix the race with collect_signal()
Message-ID: <20070825173433.GA2692@tv-sign.ru>
References: <20070823134538.GA1358@tv-sign.ru> <46CEEA94.2070902@windriver.com> <20070824074558.GA86@tv-sign.ru> <46CF4DCB.6030304@windriver.com> <20070824110836.GA74@tv-sign.ru> <46CF3988.1020408@us.ibm.com> <20070824202305.GA274@tv-sign.ru> <46D065DC.2030902@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D065DC.2030902@us.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25, Sukadev Bhattiprolu wrote:
> 
> Yes. I see it now. I had missed the SIGQUEUE_PREALLOC in __sigqueue_free().

Thanks for looking at this. This code looks simple, but it is not obvious, at
least for me.

Oleg.

