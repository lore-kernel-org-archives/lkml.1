Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbZJPI1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbZJPI1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 04:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbZJPI1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 04:27:12 -0400
Received: from smtp.nokia.com ([192.100.122.230]:39344 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbZJPI1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 04:27:11 -0400
Subject: Re: [PATCH v9 4/5] core: Add kernel message dumper to call on
 oopses and panics
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20091016080935.GA3895@elte.hu>
References: <20091015094057.7298e0d7@marrow.netinsight.se>
	 <20091015094805.754461fa@marrow.netinsight.se>
	 <20091015093133.GF10546@elte.hu>
	 <20091015161052.0752208e@marrow.netinsight.se>
	 <20091015154640.GA11408@elte.hu>
	 <20091016094601.4e2c2d3e@marrow.netinsight.se>
	 <20091016080935.GA3895@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Oct 2009 11:24:27 +0300
Message-Id: <1255681467.32489.360.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Oct 2009 08:24:29.0779 (UTC) FILETIME=[14D0FA30:01CA4E3A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 10:09 +0200, Ingo Molnar wrote:
> * Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:
> 
> /**
>  *	kmsg_dump_register - register a kernel log dumper.
>  *	@dump: pointer to the kmsg_dumper structure
>  *
>  *	Adds a kernel log dumper to the system. The dump callback in the
>  *	structure will be called when the kernel oopses or panics and must be
>  *	set. Returns zero on success and -EINVAL or -EBUSY otherwise.
>  */
> 
> Small detail - please use the KernelDoc style used in existing printk.c 
> facilities, i.e. use a single space instead of a tab:
> 
> /**
>  * kmsg_dump_register - register a kernel log dumper.
>  * @dump: pointer to the kmsg_dumper structure
>  *
>  * Adds a kernel log dumper to the system. The dump callback in the
>  * structure will be called when the kernel oopses or panics and must be
>  * set. Returns zero on success and -EINVAL or -EBUSY otherwise.
>  */

And then %-EINVAL and %-EBUSY.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

