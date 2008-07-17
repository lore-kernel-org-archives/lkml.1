Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbYGQPOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbYGQPOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbYGQPOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:14:08 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:29004 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbYGQPOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:14:07 -0400
X-IronPort-AV: E=Sophos;i="4.31,204,1215388800"; 
   d="scan'208";a="1060817"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Large increase in context switch rate
Date: Thu, 17 Jul 2008 16:14:00 +0100
Message-ID: <0E902970173AF84089673FA54B7FE78A32906B@lonpexch01.citrite.net>
In-Reply-To: <487F5F15.4050208@goop.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Large increase in context switch rate
Thread-Index: AcjoHjPhZrXBdx+zS4Ku5Hz4k7xi3AAABRRA
References: <487E43D9.7080703@goop.org> <1216286250.5232.67.camel@twins> <487F5F15.4050208@goop.org>
From: "Alex Nixon (Intern)" <Alex.Nixon@eu.citrix.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Peter Zijlstra" <peterz@infradead.org>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ian Campbell" <Ian.Campbell@eu.citrix.com>
X-OriginalArrivalTime: 17 Jul 2008 15:14:01.0872 (UTC) FILETIME=[BE8ED100:01C8E81F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah I've checked - the number of context switches seems to be around
60k regardless of whether CONFIG_PARAVIRT is switched on, and regardless
of whether it's running in domu or native (-j4 on dual core)

-----Original Message-----
From: Jeremy Fitzhardinge [mailto:jeremy@goop.org] 
Sent: 17 July 2008 16:03
To: Peter Zijlstra
Cc: Ingo Molnar; Linux Kernel Mailing List; Alex Nixon (Intern); Ian
Campbell
Subject: Re: Large increase in context switch rate

Peter Zijlstra wrote:
> Is this specific to Xen?, as a native kernel doesn't do more than ~3k
> cs/s with make -j3 on my dual core.
>   

No, it doesn't seem to be.  A CONFIG_PARAVIRT kernel running on bare 
hardware shows the same context switch rate.  Merely turning 
CONFIG_PARAVIRT on should have no effect on context switch rate (though,

Alex, it would be worth double-checking, just to be sure).

    J
