Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbYENVLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbYENVLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYENVLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:11:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34986 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751163AbYENVLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:11:45 -0400
Date: Wed, 14 May 2008 22:00:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
Message-ID: <20080514220034.51eae9e0@core>
In-Reply-To: <87fxsk7n7e.fsf@basil.nowhere.org>
References: <20080514174955.GA515@elte.hu>
	<87fxsk7n7e.fsf@basil.nowhere.org>
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

> Most of the legacy users are unlikely to be latency problems,
> simply because only very few people (or nobody) still has that hardware
> and the code will never run.
> 
> Also I wouldn't lose sleep over e.g. let ISDN continue using BKL forever.

Most of the legacy users inflict that locking on other code - eg the ISN
use of the BKL directly impacts on the tty layer work.
