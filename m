Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbYGQQEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbYGQQEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756410AbYGQQEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:04:23 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:52863 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043AbYGQQEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:04:22 -0400
X-IronPort-AV: E=Sophos;i="4.31,204,1215388800"; 
   d="scan'208";a="1061975"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Large increase in context switch rate
Date: Thu, 17 Jul 2008 17:04:20 +0100
Message-ID: <0E902970173AF84089673FA54B7FE78A32906C@lonpexch01.citrite.net>
In-Reply-To: <487F6913.2000602@goop.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Large increase in context switch rate
Thread-Index: AcjoJCliOfdZ9QeeQNap3DTg4zs5aAAAOP2Q
References: <487E43D9.7080703@goop.org> <1216286250.5232.67.camel@twins> <487F5F15.4050208@goop.org> <0E902970173AF84089673FA54B7FE78A32906B@lonpexch01.citrite.net> <487F6913.2000602@goop.org>
From: "Alex Nixon (Intern)" <Alex.Nixon@eu.citrix.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ian Campbell" <Ian.Campbell@eu.citrix.com>
X-OriginalArrivalTime: 17 Jul 2008 16:04:21.0248 (UTC) FILETIME=[C63F0800:01C8E826]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm talking about total number of context switches - kernbench gets it
from

time -f "%c" make -j 4

Dividing through it gives me a rate of around 250/sec (vs Peters 3000),
but I've set CONFIG_HZ=100 (vs Peters 1000), so they don't wildly
conflict.

Well spotted :-)

- Alex


-----Original Message-----
From: Jeremy Fitzhardinge [mailto:jeremy@goop.org] 
Sent: 17 July 2008 16:45
To: Alex Nixon (Intern)
Cc: Peter Zijlstra; Ingo Molnar; Linux Kernel Mailing List; Ian Campbell
Subject: Re: Large increase in context switch rate

Alex Nixon (Intern) wrote:
> Yeah I've checked - the number of context switches seems to be around
> 60k regardless of whether CONFIG_PARAVIRT is switched on, and
regardless
> of whether it's running in domu or native (-j4 on dual core)
>   

OK, just to be sure we're talking about the same thing, is kernbench 
displaying the context switch *rate*, or the total number of context 
switches during the build?

Peter is looking at vmstat, which is showing cs/sec.

    J
