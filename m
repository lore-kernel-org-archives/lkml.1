Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbYACSFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbYACSFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 13:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYACSFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 13:05:45 -0500
Received: from cantor.suse.de ([195.135.220.2]:37655 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbYACSFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 13:05:44 -0500
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>
Subject: Re: [RFC PATCH 00/11] mcount tracing utility
From: Andi Kleen <andi@firstfloor.org>
References: <20080103071609.478486470@goodmis.org>
Date: Thu, 03 Jan 2008 19:05:42 +0100
In-Reply-To: <20080103071609.478486470@goodmis.org> (Steven Rostedt's message of "Thu\, 03 Jan 2008 02\:16\:09 -0500")
Message-ID: <p73wsqqg4y1.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> The following patch series brings to vanilla Linux a bit of the RT kernel
> trace facility. This incorporates the "-pg" profiling option of gcc
> that will call the "mcount" function for all functions called in
> the kernel.

My personal feeling regarding this code was that it would be much simpler/cleaner
to implement a driver for the "jump tracer"s implemented in various CPUs.
Basically the CPU will write all jumps into a buffer by itself. That
allows you to do many traces (although not latency traces) too.

-Andi
