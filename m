Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbZCYJ3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbZCYJ3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbZCYJ3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:29:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbZCYJ3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:29:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/5] ptrace: remove incorrect unlikelys
In-Reply-To: Steven Rostedt's message of  Wednesday, 25 March 2009 01:19:21 -0400 <20090325052022.747507467@goodmis.org>
References: <20090325051920.406564281@goodmis.org>
	<20090325052022.747507467@goodmis.org>
Emacs: a Lisp interpreter masquerading as ... a Lisp interpreter!
Message-Id: <20090325092818.8742CFC336@magilla.sf.frob.com>
Date: Wed, 25 Mar 2009 02:28:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is mislabeled, really.  This is "x86: syscall-audit", not ptrace.

I think this one also warrants moving the if inside a generic (non-arch)
inline.  The choice about unlikely() is not arch-specific, nor (AFIAK) is
the logic of the if.


Thanks,
Roland
