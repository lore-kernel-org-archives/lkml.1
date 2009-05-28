Return-Path: <linux-kernel-owner+w=401wt.eu-S932271AbZE1AKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbZE1AKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758284AbZE1AKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:10:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55186 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757132AbZE1AKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:10:22 -0400
Date: Thu, 28 May 2009 02:05:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: do_notify_parent_cldstop: fix the wrong
	->nsproxy usage
Message-ID: <20090528000507.GA13390@redhat.com>
References: <20090525185502.GA20781@redhat.com> <20090526210514.C1C91FC2BD@magilla.sf.frob.com> <20090527213222.GA6770@redhat.com> <20090527222337.0507EFC36B@magilla.sf.frob.com> <20090527231248.GB10032@redhat.com> <20090527232617.2FE48FC2BD@magilla.sf.frob.com> <20090527234330.GA12216@redhat.com> <20090527235136.A44A4FC2BD@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527235136.A44A4FC2BD@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27, Roland McGrath wrote:
>
> > Yes, but the (minor and low priority) problem is that .si_pid recorded
> > in ->last_siginfo does not match the tracee's pid from the tracer pov
> > (if they run in different namespaces).
>
> That is not a problem, it's how it's supposed to be.  That's what I was
> just saying.  This is information about the values seen by the debugged
> process.

Ah, OK then.

I misunderstood you.

Oleg.

