Return-Path: <linux-kernel-owner+w=401wt.eu-S1763367AbYGOV0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763367AbYGOV0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763365AbYGOV0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:26:23 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51507 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758577AbYGOV0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:26:22 -0400
Message-ID: <487D15FC.1060300@sgi.com>
Date: Tue, 15 Jul 2008 14:26:20 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: [git pull] core/percpu for v2.6.27
References: <20080714143413.GA19134@elte.hu> <alpine.LFD.1.10.0807141525000.2944@woody.linux-foundation.org> <487CC671.3000501@goop.org> <20080715210002.GA7072@elte.hu>
In-Reply-To: <20080715210002.GA7072@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

...
> 
> in hindsight core/percpu indeed looks unfinished and direction-less 
> without core/percpu-zerobased - but the latter is not stable yet.
> 
> 	Ingo

Well it's very stable using gcc-4.2.4.  The earlier problems came about
using gcc-4.2.0 and has yet to be determined what exactly went wrong.
(And I need to install gcc-3.2 to complete the build/test QA.)

Btw, is there a list of "bad" gcc's for kernel building?  Or better yet,
can the Makefile script provide a warning when a known "bad" gcc is
being used to compile the kernel?  I seem to recall that Peter provided
this list:

	4.2.3 is fine; he was using 4.2.0 before, and as far as I know,
        4.2.0 and 4.2.1 are known broken for the kernel.

Thanks!
Mike
