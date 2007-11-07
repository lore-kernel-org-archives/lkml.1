Return-Path: <linux-kernel-owner+w=401wt.eu-S1759878AbXKGXuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878AbXKGXuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 18:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757643AbXKGXul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 18:50:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257AbXKGXuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 18:50:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeff Dike <jdike@addtoit.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@osdl.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, Chuck Ebbert <76306.1226@compuserve.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 - 32-bit ptrace emulation mishandles 6th arg
In-Reply-To: Jeff Dike's message of  Wednesday, 7 November 2007 18:41:50 -0500 <20071107234150.GA10520@c2.user-mode-linux.org>
References: <20071107154839.GA5981@c2.user-mode-linux.org>
	<20071107211222.B95634D0564@magilla.localdomain>
	<20071107234150.GA10520@c2.user-mode-linux.org>
X-Windows: power tools for power losers.
Message-Id: <20071107235031.EEAA64D0564@magilla.localdomain>
Date: Wed,  7 Nov 2007 15:50:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, http://sourceware.org/systemtap/wiki/utrace/tests has details on the
ptrace-tests suite we're collecting.  A test I added there is how I noticed
the PTRACE_GET_THREAD_AREA regression.  A regression test for the ebp bug
should be easy to add too.


Thanks,
Roland
