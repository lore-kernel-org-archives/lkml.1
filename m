Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbXJBP4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbXJBP4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756664AbXJBPxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:53:45 -0400
Received: from station18k.dscga.com ([192.24.222.18]:43754 "EHLO
	suzuka.mcnaught.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755617AbXJBPxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:53:44 -0400
X-Greylist: delayed 1765 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Oct 2007 11:53:44 EDT
To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "David Schwartz" <davids@webmaster.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: yield API
References: <20071001173159.GB2492@elte.hu>
	<MDEHLPKNGKAHNMBLJOLKOEOBHCAC.davids@webmaster.com>
	<20071002064620.GA26638@elte.hu>
	<Pine.LNX.4.61.0710020733270.16314@chaos.analogic.com>
From: Douglas McNaught <doug@mcnaught.org>
Date: Tue, 02 Oct 2007 11:24:18 -0400
In-Reply-To: <Pine.LNX.4.61.0710020733270.16314@chaos.analogic.com> (linux-os@analogic.com's
 message of "Tue, 2 Oct 2007 07:50:39 -0400")
Message-ID: <878x6lwndp.fsf@suzuka.mcnaught.org>
User-Agent: Gnus/5.1006 (Gnus v5.10.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"linux-os \(Dick Johnson\)" <linux-os@analogic.com> writes:

> Whether or not there is a POSIX definition of sched_yield(),
> there is a need for something that will give up the CPU
> and not busy-wait. There are many control applications
> where state-machines are kept in user-mode code. The code
> waits for an event. It shouldn't be spinning, wasting
> CPU time, when the kernel can be doing file and network
> I/O with the wasted CPU cycles.

These "control applications" would be real-time processes, for which
(AIUI) sched_yield() behavior is completely well-defined and
implemented as such by Linux.  The question here is how useful the
call is for SCHED_OTHER (non-real-time) processes, for which it has no
well-defined semantics.

-Doug
