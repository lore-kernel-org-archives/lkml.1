Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbXLHRUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbXLHRUR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 12:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbXLHRUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 12:20:05 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:24898 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbXLHRUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 12:20:02 -0500
Subject: Re: lockdep problem conversion semaphore->mutex (dev->sem)
From: Daniel Walker <dwalker@mvista.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Remy Bohmer <linux@bohmer.net>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Dave Chinner <dgc@sgi.com>
In-Reply-To: <1197133910.6353.33.camel@lappy>
References: <3efb10970712071502p4db9c58ck623c377172ead4b2@mail.gmail.com>
	 <1197116185.31440.1.camel@twins>
	 <1197132792.1568.162.camel@jnielson-xp.ddns.mvista.com>
	 <1197133910.6353.33.camel@lappy>
Content-Type: text/plain
Date: Sat, 08 Dec 2007 09:06:16 -0800
Message-Id: <1197133577.1568.166.camel@jnielson-xp.ddns.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-12-08 at 18:11 +0100, Peter Zijlstra wrote:

> > It must be the locking in __driver_attach(), taking dev->parent->sem
> > then taking dev->sem .. Assuming those are different structures, why
> > does lockdep trigger?
> 
> They aren't different, parent is a struct device again.

It's different memory tho .. I wasn't sure how to term that .. The locks
are in two different memory location so it couldn't be recursive .. I'm
only asking for my own understanding .. I don't mind inspecting
potentially bad locking ..

Daniel

