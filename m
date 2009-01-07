Return-Path: <linux-kernel-owner+w=401wt.eu-S1761728AbZAGVIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761728AbZAGVIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759172AbZAGVIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:08:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49876
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761616AbZAGVIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:08:34 -0500
Date: Wed, 07 Jan 2009 13:08:36 -0800 (PST)
Message-Id: <20090107.130836.128453234.davem@davemloft.net>
To: mingo@elte.hu
Cc: sam@ravnborg.org, kosaki.motohiro@jp.fujitsu.com, yinghai@kernel.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: irqnr fallout in gpiolib on sparc32
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090107130213.GB3529@elte.hu>
References: <20090106125704.GC20407@elte.hu>
	<20090106.082913.97432854.davem@davemloft.net>
	<20090107130213.GB3529@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 7 Jan 2009 14:02:13 +0100

> Each of them crying out loud to be unified. Every time you open irq_64.c 
> you'll think "why that ugly _64.c postfix, shouldnt this be irq.c 
> instead?" ;-)

Doesn't work very well when you have sun4c_irq.c, sun4m_irq.c,
and sun4d_irq.c sitting right next to them.

Sparc32 is miles away from sparc64 in terms of being easy to make
use generic IRQs.

It's a lot of hard work and testing of which I have to rely upon
helpers to perform.  The sparc arch directory consolidation in no way
makes me want to do that work any more or any less, no matter how many
times I open up irq_64.c :-)

