Return-Path: <linux-kernel-owner+w=401wt.eu-S1761563AbZCZUXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761563AbZCZUXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757452AbZCZUXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:23:14 -0400
Received: from bowden.ucwb.org.au ([203.122.237.119]:48286 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbZCZUXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:23:13 -0400
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090324114409.GB6058@nowhere>
References: <qm8_cedJGaP.A.-NH.CPCvJB@chimera>
	 <1237107837.27699.27.camel@kulgan.wumi.org.au>
	 <49BE20B2.9070804@redhat.com> <1237207595.4964.31.camel@kulgan.wumi.org.au>
	 <20090316200736.GD8393@nowhere>
	 <1237244137.4964.54.camel@kulgan.wumi.org.au>
	 <20090318001955.GB5143@nowhere>
	 <1237338986.4801.11.camel@kulgan.wumi.org.au>
	 <1237411441.5211.5.camel@kulgan.wumi.org.au>
	 <1237611639.4933.4.camel@kulgan.wumi.org.au>
	 <20090324114409.GB6058@nowhere>
Content-Type: text/plain
Organization: UnitingCare Wesley Bowden
Date: Fri, 27 Mar 2009 06:52:57 +1030
Message-Id: <1238098977.5406.5.camel@kulgan>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-24 at 12:44 +0100, Frederic Weisbecker wrote:
> As I explained in my previous mail, you trace is only
> a snapshot that happened in 10 msec.
> 
> I experimented different sizes for the ring buffer but even
> a 1 second trace require 20 Mo of memory. And a so huge trace
> would be impractical.
> 
> I think we should keep the trace filters we had previously.
> If you don't minde, could you please retest against latest -tip
> the following updated patch? Iadded the filters, fixed the python
> subshell and also flushed the buffer more nicely according to
> a recent feature in -tip:
> 
> echo > trace 
> 
> instead of switching to nop.
> You will need to pull latest -tip again.

Ok, new set of traces uploaded again here:

  http://disenchant.net/tmp/bug-12465/trace-4/

These were taken using 2.6.29-tip-02749-g398bf09.

Same as last time, it was only necessary to have the one guest running
to reproduce the problem.

Cheers,
Kevin.


