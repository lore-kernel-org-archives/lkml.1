Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbYHSSvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbYHSSvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbYHSSvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:51:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbYHSSvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:51:09 -0400
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       "Randy.Dunlap" <rdunlap@xenotime.net>, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, mpm@selenic.com,
       tglx@linutronix.de, rostedt@goodmis.org, cl@linux-foundation.org,
       tzanussi@gmail.com
Subject: Re: [PATCH 1/5] Revert "kmemtrace: fix printk format warnings"
References: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro>
	<Pine.LNX.4.64.0808191049260.7877@shark.he.net>
	<20080819175440.GA5435@localhost> <20080819181652.GA29757@Krystal>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 19 Aug 2008 14:47:16 -0400
In-Reply-To: <20080819181652.GA29757@Krystal> (Mathieu Desnoyers's message of "Tue, 19 Aug 2008 14:16:53 -0400")
Message-ID: <y0md4k4zvt7.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:

> [...]
> Is this kmemtrace marker meant to be exposed to userspace ?
> I suspect not.
> [...]
> Tracepoints = in-kernel tracing API.
> Markers = Data-formatting tracing API, meant to export the data either
> to user-space in text or binary format.

FWIW, that was certainly not the intent of markers.  It was to try to
satisfy both sorts of uses with relative type-safety and a minimum of
code.  Tracepoints may be nice if one needs somewhat (how much?) more
performance, and is willing to burden someone else with the necessary
extra code (such as tracepoint-to-marker conversion modules) to expose
the same data to "userspace" tools like lttng/systemtap.

- FChE
