Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbZKJIWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbZKJIWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 03:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbZKJIWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 03:22:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:52206 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbZKJIWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 03:22:05 -0500
Subject: Re: [PATCH] kernel.h: Add printk_ratelimited and pr_<level>_rl
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
       Naohiro Ooiwa <nooiwa@miraclelinux.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, roland@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, oleg@redhat.com
In-Reply-To: <20091110073909.GA8874@elte.hu>
References: <4AEACFBF.4060108@miraclelinux.com>
	 <20091030143333.414ea29c.akpm@linux-foundation.org>
	 <1256939158.1917.43.camel@Joe-Laptop.home>
	 <1256944907.1917.109.camel@Joe-Laptop.home>
	 <20091109134914.70de28cf.akpm@linux-foundation.org>
	 <20091110051734.GG7897@elte.hu> <1257838493.21088.6.camel@twins>
	 <20091110073909.GA8874@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 10 Nov 2009 09:21:56 +0100
Message-ID: <1257841316.9767.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 08:39 +0100, Ingo Molnar wrote:
> 
> printk wont go away as an ad-hoc print-this tool. (Nor will we convert 
> most of the remaining 18,000+ uses of printk() in the kernel, so 
> printk() will be with us forever i guess.)

Ok good, /me purges all knowledge of pr_* and will henceforth ignore
it ;-)
