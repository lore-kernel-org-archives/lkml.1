Return-Path: <linux-kernel-owner+w=401wt.eu-S934297AbZJGSfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934297AbZJGSfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757223AbZJGSff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:35:35 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:61542 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756662AbZJGSfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:35:34 -0400
From: Frans Pop <elendil@planet.nl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for CPU"
Date: Wed, 7 Oct 2009 20:34:55 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
References: <200910051500.55875.elendil@planet.nl> <200910061749.02805.elendil@planet.nl> <200910071910.53907.elendil@planet.nl>
In-Reply-To: <200910071910.53907.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910072034.57511.elendil@planet.nl>
X-OriginalArrivalTime: 07 Oct 2009 18:34:57.0984 (UTC) FILETIME=[DF35C400:01CA477C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 October 2009, Frans Pop wrote:
> On Tuesday 06 October 2009, Frans Pop wrote:
> > I've checked for 2.6.31.1 now and iwlagn is listed high there too when
> > the system is idle, but with normal values of 60-100 ms. And phy0 has
> > normal values of below 10 ms.
> > I've now rebooted with today's mainline git; phy0 now frequently shows
> > with values of around 100 ms too (i.e. higher than last time).
>
> Mike privately sent me a script to try to capture the latencies with
> perf, but the perf output does not show any high latencies at all. It
> looks as if we may have found a bug in latencytop here instead.

Not sure if it's relevant nor what it means, but I frequently see two lines 
for iwlagn, e.g:

    Scheduler: waiting for cpu              102.4 msec         99.7 %
    .                                         3.3 msec          0.3 %

I get the same results with both latencytop 0.4 and 0.5.
