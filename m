Return-Path: <linux-kernel-owner+w=401wt.eu-S1758702AbZIGCFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702AbZIGCFY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 22:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758559AbZIGCFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 22:05:23 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:59951 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758556AbZIGCFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 22:05:23 -0400
From: Frans Pop <elendil@planet.nl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Mon, 7 Sep 2009 04:05:22 +0200
User-Agent: KMail/1.9.9
Cc: kernel@kolivas.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       efault@gmx.de
References: <20090906205952.GA6516@elte.hu>
In-reply-To: <20090906205952.GA6516@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909070405.23936.elendil@planet.nl>
X-OriginalArrivalTime: 07 Sep 2009 02:05:24.0815 (UTC) FILETIME=[A9A6A5F0:01CA2F5F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> So the testbox i picked fits into the upper portion of what i
> consider a sane range of systems to tune for - and should still fit
> into BFS's design bracket as well according to your description:
> it's a dual quad core system with hyperthreading.

Ingo,

Nice that you've looked into this.

Would it be possible for you to run the same tests on e.g. a dual core 
and/or a UP system (or maybe just offline some CPUs?)? It would be very 
interesting to see whether BFS does better in the lower portion of the 
range, or if the differences you show between the two schedulers are 
consistent across the range.

Cheers,
FJP
