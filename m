Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab0BTN6A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 08:58:00 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:49365 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab0BTN57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 08:57:59 -0500
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20100220134447.GA3000@hack>
References: <1264740107.20211.53.camel@pasglop>
	 <1266485775.6539.6.camel@jlt3.sipsolutions.net>
	 <alpine.LFD.2.00.1002180825000.4141@localhost.localdomain>
	 <1266518735.3829.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002192313j3fb84acje4c286c4f86457f3@mail.gmail.com>
	 <1266656213.5347.0.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200106j56b0298ds1a425fde8983d988@mail.gmail.com>
	 <1266665331.12525.0.camel@jlt3.sipsolutions.net>
	 <20100220134447.GA3000@hack>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Feb 2010 14:57:48 +0100
Message-ID: <1266674268.18465.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-20 at 21:44 +0800, Américo Wang wrote:

> That message is displayed before shutting down the devices.
> 
> To verify, you can add some printk() in the end of
> __cpufreq_remove_dev(), or enable CONFIG_CPU_FREQ_DEBUG.

That is already enabled.

johannes

