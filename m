Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbZJPIKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbZJPIKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 04:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbZJPIKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 04:10:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34083 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbZJPIKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 04:10:36 -0400
Date: Fri, 16 Oct 2009 10:09:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v9 4/5] core: Add kernel message dumper to call on
	oopses and panics
Message-ID: <20091016080935.GA3895@elte.hu>
References: <20091015094057.7298e0d7@marrow.netinsight.se> <20091015094805.754461fa@marrow.netinsight.se> <20091015093133.GF10546@elte.hu> <20091015161052.0752208e@marrow.netinsight.se> <20091015154640.GA11408@elte.hu> <20091016094601.4e2c2d3e@marrow.netinsight.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091016094601.4e2c2d3e@marrow.netinsight.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:

/**
 *	kmsg_dump_register - register a kernel log dumper.
 *	@dump: pointer to the kmsg_dumper structure
 *
 *	Adds a kernel log dumper to the system. The dump callback in the
 *	structure will be called when the kernel oopses or panics and must be
 *	set. Returns zero on success and -EINVAL or -EBUSY otherwise.
 */

Small detail - please use the KernelDoc style used in existing printk.c 
facilities, i.e. use a single space instead of a tab:

/**
 * kmsg_dump_register - register a kernel log dumper.
 * @dump: pointer to the kmsg_dumper structure
 *
 * Adds a kernel log dumper to the system. The dump callback in the
 * structure will be called when the kernel oopses or panics and must be
 * set. Returns zero on success and -EINVAL or -EBUSY otherwise.
 */

(in the other functions as well)

	Ingo
