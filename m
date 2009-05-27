Return-Path: <linux-kernel-owner+w=401wt.eu-S1759136AbZE0Q4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136AbZE0Q4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 12:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbZE0Q4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 12:56:43 -0400
Received: from www.tglx.de ([62.245.132.106]:34932 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbZE0Q4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 12:56:43 -0400
Date: Wed, 27 May 2009 18:56:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Friesen <cfriesen@nortel.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ulrich Drepper <drepper@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: linux missing support for _POSIX_THREAD_CPUTIME?
In-Reply-To: <4A1D6E71.90602@nortel.com>
Message-ID: <alpine.LFD.2.00.0905271855290.3397@localhost.localdomain>
References: <4A1D6E71.90602@nortel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Chris Friesen wrote:

That's more a question for the glibc folks. CC'ed.

> Hi all,
> 
> POSIX defines optional support for clock ID values obtained by invoking
> pthread_getcpuclockid().  When passed to clock_gettime(), this allows
> the caller to request the CPU-time clock of an arbitrary thread within
> the same process as the caller.
> 
> It appears that linux doesn't support this functionality--is that
> correct?  Is there any plan to enable this?
> 
> Is there any current way to obtain the runtime of a particular thread
> without knowing its tid (since the thread_id to tid mapping is known
> only to glibc)?
> 
> Thanks,
> 
> Chris
> 
