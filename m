Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbYGLM3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbYGLM3x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 08:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYGLM3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 08:29:46 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:21057 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbYGLM3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 08:29:46 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Elias Oltmanns <eo@nebensachen.de>,
       =?utf-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86_64: fix delayed signals
From: Andi Kleen <andi@firstfloor.org>
References: <20080710215039.2A143154218@magilla.localdomain>
	<20080711054605.GA17851@elte.hu>
	<alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org>
Date: Sat, 12 Jul 2008 14:27:47 +0200
In-Reply-To: <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org> (Linus Torvalds's message of "Fri, 11 Jul 2008 10:58:54 -0700 (PDT)")
Message-ID: <87mykn2sos.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Jul 2008 12:20:21.0137 (UTC) FILETIME=[A7401810:01C8E419]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

Linus, the fact that is not explained by your theory is why
Ctrl-Z+kill works but Ctrl-C doesn't. On the signal side these
both should be implemented in the same way -- if there was
really a missing signal_pending() check somewhere then Ctrl-Z
(and kill) should be delayed too.

Now doing faster signal processing is always a good thing in general,
but I'm a little doubtful your patch will help with that
particular problem.

-Andi
