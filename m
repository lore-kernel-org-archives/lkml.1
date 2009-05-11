Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbZEKPua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbZEKPua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbZEKPuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:50:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbZEKPuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:50:16 -0400
To: Christoph Hellwig <hch@infradead.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH -tip v5 4/7] tracing: add kprobe-based event tracer
References: <20090509004829.5505.38720.stgit@localhost.localdomain>
	<20090509004859.5505.18729.stgit@localhost.localdomain>
	<20090511093224.GC23875@infradead.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Mon, 11 May 2009 11:28:12 -0400
In-Reply-To: <20090511093224.GC23875@infradead.org> (Christoph Hellwig's message of "Mon, 11 May 2009 05:32:24 -0400")
Message-ID: <y0m8wl3ek1f.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> [...]  But as with so many tracing bits in the kernel it's just
> lowlevel bits without a good user interface.  We'd really need some
> high-level way for sysadmins/developers to use it.  E.g. a version
> of the systemtap compiler that doesn't build a kernel module but
> instead uses the event tracer + the kprobes tracer. [...]

This (the translator detecting that a particular script is simple
enough to be executed in this manner) is theoretically possible.

- FChE
