Return-Path: <linux-kernel-owner+w=401wt.eu-S1752448AbYLYLA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbYLYLA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 06:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYLYLAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 06:00:48 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43368 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYLYLAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 06:00:47 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH for -tip] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
Cc: kosaki.motohiro@jp.fujitsu.com, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081225105915.GA11560@elte.hu>
References: <20081225194440.50ED.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081225105915.GA11560@elte.hu>
Message-Id: <20081225200020.50F0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 25 Dec 2008 20:00:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > 
> > I confirmed by alpha cross compiler.
> > 
> > ==
> > Subject: [PATCH] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
> > Impact: cleanup
> > 
> > commit 240d367b4e6c6e3c5075e034db14dba60a6f5fa7 has a bit strange analysis.
> > The fact is, irq_desc() can be used old architecuture too. 
> > but old code don't include <linux/irq.h>.
> > 
> > right fixing is here.
> 
> > +#include <linux/irq.h>
> 
> looks good, but linux/irq.h cannot be included on all architectures. (for 
> example s390 has no notion of 'hardirqs'). But we created linux/irqnr.h 
> for this purpose - so including that should work better.

Oh, thanks good explain.
I'll fix soon.



