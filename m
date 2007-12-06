Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbXLFVb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbXLFVb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 16:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbXLFVbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 16:31:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbXLFVbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 16:31:51 -0500
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch-RFC 00/26] LTTng Kernel Trace Thread Flag
References: <20071206024243.397994403@polymtl.ca>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 06 Dec 2007 16:30:21 -0500
In-Reply-To: <20071206024243.397994403@polymtl.ca> (Mathieu Desnoyers's message of "Wed, 05 Dec 2007 21:42:43 -0500")
Message-ID: <y0mmysnzf2q.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:

> This is an RFC for addition of a new thread flag, TIF_KERNEL_TRACE, to each
> architecture to activate system-wide system call tracing.
> [...]

Instead of creating a new flag, could you overload TIF_SYSCALL_TRACE,
putting the marker into syscall_trace(), and letting !PT_TRACED cause
a skip over the ptrace notification logic?

- FChE
