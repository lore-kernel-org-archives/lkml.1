Return-Path: <linux-kernel-owner+w=401wt.eu-S1945983AbXBPQbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945983AbXBPQbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945981AbXBPQbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:31:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932457AbXBPQbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:31:11 -0500
To: Jeff Muizelaar <jeff@infidigm.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Using sched_clock for mmio-trace
References: <20070216013024.GA32287@infidigm.net>
From: fche@redhat.com (Frank Ch. Eigler)
Date: 16 Feb 2007 11:30:56 -0500
In-Reply-To: <20070216013024.GA32287@infidigm.net>
Message-ID: <y0mr6sq2hfj.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.0808 (Gnus v5.8.8) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Muizelaar <jeff@infidigm.net> writes:

> I've built a tool with the goal of logging mmio writes and reads by
> device drivers. See http://nouveau.freedesktop.org/wiki/MmioTrace.

FWIW, this is exactly a type of add-on trace patch that could be
mooted by adoption of the ltt/systemtap "marker" facility.  With it,
you would not need so much code (e.g. no new user-space tools at all,
reuse of common tracing buffer logic, permanently placed hooks) and
would probably get more utility.

> [...]  The question is, what [timer] api should I be using? I need
> something that can be called from inside interrupt handlers, and
> obviously the more accurate and the lower the overhead the better.

We in systemtap land have the same problem, and so far made do with
slightly postprocessed per-cpu TSC values.


- FChE
