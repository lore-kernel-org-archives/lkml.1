Return-Path: <linux-kernel-owner+w=401wt.eu-S1762226AbZCPWz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762226AbZCPWz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZCPWzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:55:49 -0400
Received: from bowden.ucwb.org.au ([203.122.237.119]:42124 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbZCPWzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:55:48 -0400
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090316200736.GD8393@nowhere>
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera>
	 <qm8_cedJGaP.A.-NH.CPCvJB@chimera>
	 <1237107837.27699.27.camel@kulgan.wumi.org.au>
	 <49BE20B2.9070804@redhat.com> <1237207595.4964.31.camel@kulgan.wumi.org.au>
	 <20090316200736.GD8393@nowhere>
Content-Type: text/plain
Organization: UnitingCare Wesley Bowden
Date: Tue, 17 Mar 2009 09:25:37 +1030
Message-Id: <1237244137.4964.54.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-16 at 21:07 +0100, Frederic Weisbecker wrote:
> I've looked a bit at your traces.
> I think it's probably too wide to find something inside.
> Latest -tip is provided with a new set of events tracing, meaning
> that you will be able to produce function graph traces with various
> sched events included.
> 
> Another thing, is it possible to reproduce it with only one ping?
> Or testing perioding pings and keep only one that raised a relevant
> threshold of latency? I think we could do a script that can do that.
> It would make the trace much clearer.

Yeah, I think that should be possible. If you can come up with such a
script, that would be great.

> Just wait a bit, I'm looking at which event could be relevant to enable
> and I come back to you with a set of commands to test.

Excellent! Thanks for looking into this.

Cheers,
Kevin.


