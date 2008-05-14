Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbYENV5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbYENV5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbYENV5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:57:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46936 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751874AbYENV5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:57:40 -0400
Date: Wed, 14 May 2008 22:46:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
Message-ID: <20080514224600.5bb5db5c@core>
In-Reply-To: <20080514174955.GA515@elte.hu>
References: <20080514174955.GA515@elte.hu>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Out of amusement I took the watchdog drivers and started looking for
large cans of worms in the BKL drop arena.

Here is a fun one for general discussion - right now driver probe
functions request resources. We have no ordering on the requests so we
have deadlocks if two drivers do resource requests for conflicting
resources in reverse order.

"Discuss"

Alan
