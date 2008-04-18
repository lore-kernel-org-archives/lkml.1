Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbYDRGjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbYDRGjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 02:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbYDRGi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 02:38:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55273
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753355AbYDRGi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 02:38:57 -0400
Date: Thu, 17 Apr 2008 23:38:56 -0700 (PDT)
Message-Id: <20080417.233856.238029159.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, arjan@infradead.org
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080417232747.4c04f413.akpm@linux-foundation.org>
References: <20080416202338.GA6007@elte.hu>
	<20080417232747.4c04f413.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 17 Apr 2008 23:27:47 -0700

> On Wed, 16 Apr 2008 22:23:38 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Arjan van de Ven (6):
> >	...
> >       x86: mark init_mm deprecated
> 
> Why can't I find this patch on the mailing list?
> 
> It's an MM patch which touches sched.h.  It should not be in git-x86.
> 
> It generates over a megabyte of warnings on sparc64.

If you're going to touch generic code, test build on other
platforms or get it into a tree where such build testing is
done for you.
