Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067AbZLTSVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbZLTSVx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 13:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbZLTSVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 13:21:52 -0500
Received: from mail.perches.com ([173.55.12.10]:1330 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbZLTSVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 13:21:52 -0500
Subject: Re: sched: restore sanity
From: Joe Perches <joe@perches.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, San Mehat <san@google.com>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20091220191725.1799eab7@infradead.org>
References: <1261315437.4314.6.camel@laptop>
	 <20091220144925.GA19608@elte.hu> <1261320715.4314.9.camel@laptop>
	 <236ccac0912200703g464912b1r421497ebf3b6ebc6@mail.gmail.com>
	 <236ccac0912200705i369d00d1v42603a00e92039b6@mail.gmail.com>
	 <1261322387.4314.22.camel@laptop>
	 <1261329743.30458.179.camel@Joe-Laptop.home>
	 <20091220191725.1799eab7@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Dec 2009 10:21:50 -0800
Message-ID: <1261333310.30458.205.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 19:17 +0100, Arjan van de Ven wrote:
> On Sun, 20 Dec 2009 09:22:23 -0800 Joe Perches <joe@perches.com> wrote:
> > What are the negatives of using pr_<level>?
> pr_ is really just for "I am a driver and want a single line message
> out in a standardized format".
> Nothing wrong with that.
> 
> But here you are changing fundamental kernel outputs in the style of an
> oops message. Multiline, complex and machine parsed things...

The prefixing was trivial to change.
No other output was modified.

I believe kernel log output is specifically _not_ guaranteed
and should not be so guaranteed to remain stable across
versions.


