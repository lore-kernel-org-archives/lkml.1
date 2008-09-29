Return-Path: <linux-kernel-owner+w=401wt.eu-S1752372AbYI2Fj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbYI2Fj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 01:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYI2Fjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 01:39:51 -0400
Received: from qmta03.westchester.pa.mail.comcast.net ([76.96.62.32]:36921
	"EHLO QMTA03.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558AbYI2Fju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 01:39:50 -0400
X-Authority-Analysis: v=1.0 c=1 a=SroaiyepabgA:10 a=eeeSsMHp9ioA:10
 a=mzo2CHdUZoLpmauBL-8A:9 a=50bSAm_x3gRECWlqO6YA:7
 a=N5_Ag-Zd87PSBgUhA9GuJovVGKAA:4 a=b8hG5vVbyAkA:10
Subject: [RFC PATCH 0/11] relay revamp, fourth installment
From: Tom Zanussi <zanussi@comcast.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>
Content-Type: text/plain
Date: Mon, 29 Sep 2008 00:39:47 -0500
Message-Id: <1222666787.7637.173.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the final installment of the relay cleanup patchset.

1-2 make the write path completely replaceable.
3 adds flags along with some related cleanup.
4-8 remove the padding in several stages.
9 simplifies the callbacks
10 removes the concept of sub-buffers

The new patches in this set are:

11 - remove the vmap of relay buffers

I think I've basically accomplished what I wanted to with this patchset
- getting rid of everything that was unnecessary and unused and fixing a
couple of small design mistakes has made both the interface and the code
much cleaner, closer to what it should have been from the beginning.
The fact that it took less than a week of part-time hacking I think
shows that the problems were mostly superficial, and the patches
themselves pretty much reflect that - something in hindsight that should
have been done long ago.

I don't plan on doing any more with this - if anyone else wants to, feel
free.  In the meantime, until the unified trace buffer replaces it, the
current relay AFAIK works just fine and performs well for its existing
users, so actually making these or any other changes at this point would
I think be a wasted effort.

Tom


