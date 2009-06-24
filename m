Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbZFXQd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbZFXQd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZFXQds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:33:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363AbZFXQdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:33:47 -0400
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>,
       Tom Zanussi <tzanussi@gmail.com>, karim@opersys.com,
       Michel Dagenais <michel.dagenais@polymtl.ca>,
       ltt-dev@lists.casi.polymtl.ca, Lai Jiangshan <laijs@cn.fujitsu.com>,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Robert Wisniewski <bob@watson.ibm.com>
Subject: Re: Dual-licensing LTTng, marker and tracepoints under GPLv2+/LGPLv2.1+
References: <4A412702.80707@polymtl.ca> <20090623191128.GA19010@Krystal>
	<20090623191513.GA20253@Krystal> <20090624004356.GB28911@Krystal>
	<20090624083334.GB16850@elte.hu> <20090624141438.GA15420@Krystal>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Wed, 24 Jun 2009 12:33:00 -0400
In-Reply-To: <20090624141438.GA15420@Krystal> (Mathieu Desnoyers's message of "Wed, 24 Jun 2009 10:14:39 -0400")
Message-ID: <y0mprctzj5v.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <compudj@krystal.dyndns.org> writes:

> [...]  The goal we pursue by dual-licensing with GPLv2/LGPLv2.1 is
> to permit instrumented applications to be themselves distributed
> under other license than GPL. [...]

Is there some reason you can't just fork/copy off some earlier version
of these files over which you had sole authorship (if any)?


> [...]The goal is to permit this library, which includes the
> tracepoints, markers and LTTng features, to be used by userspace
> applications and libraries so they can add static instrumentation
> (as we currently do in the kernel). [...]

Just in case you're not aware, some API prior art for this is the
dtrace sdt.h widget (already supported by systemtap), and of course
it has no similarity to the various kernel tracing APIs.

- FChE
