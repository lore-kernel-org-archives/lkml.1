Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbYHKPiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbYHKPiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbYHKPio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:38:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbYHKPin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:38:43 -0400
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mathieu.desnoyers@polymtl.ca, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net, mpm@selenic.com,
       tglx@linutronix.de
Subject: Re: [PATCH 4/5] kmemtrace: SLUB hooks.
References: <1218388447-5578-1-git-send-email-eduard.munteanu@linux360.ro>
	<1218388447-5578-2-git-send-email-eduard.munteanu@linux360.ro>
	<1218388447-5578-3-git-send-email-eduard.munteanu@linux360.ro>
	<1218388447-5578-4-git-send-email-eduard.munteanu@linux360.ro>
	<1218388447-5578-5-git-send-email-eduard.munteanu@linux360.ro>
	<48A046F5.2000505@linux-foundation.org>
	<1218463774.7813.291.camel@penberg-laptop>
	<48A048FD.30909@linux-foundation.org>
	<alpine.DEB.1.10.0808111027370.29861@gandalf.stny.rr.com>
	<48A04EC2.1080302@linux-foundation.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Mon, 11 Aug 2008 11:34:09 -0400
In-Reply-To: <48A04EC2.1080302@linux-foundation.org> (Christoph Lameter's message of "Mon, 11 Aug 2008 09:37:54 -0500")
Message-ID: <y0mhc9ra7m6.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux-foundation.org> writes:

> [...]
>> There should be no extra function calls when this is configured on but 
>> tracing disabled. We try very hard to keep the speed of the tracer as 
>> close to a non tracing kernel as possible when tracing is disabled.
>
> Makes sense. But then we have even more code bloat because of the
> tests that are inserted in all call sites of kmalloc.

Are you talking about the tests that implement checking whether a
marker is active or not?  Those checks are already efficient, and will
get more so with the "immediate values" optimization in or near the
tree.

- FChE
