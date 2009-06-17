Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbZFQQM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbZFQQM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbZFQQMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:12:50 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:57511 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755454AbZFQQMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:12:50 -0400
From: Frans Pop <elendil@planet.nl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH]x86-tsc.c : fix compile warning
Date: Wed, 17 Jun 2009 18:12:49 +0200
User-Agent: KMail/1.9.9
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>,
       "Figo.zhang" <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       Sumit Panchasara <sumit.panchasara@einfochips.com>,
       "'Sachin P Sant'" <sachinp@linux.vnet.ibm.com>,
       "'H. Peter Anvin'" <hpa@zytor.com>,
       "'Andi Kleen'" <andi@firstfloor.org>,
       "'Thomas Gleixner'" <tglx@linutronix.de>,
       "'Balbir Singh'" <balbir@linux.vnet.ibm.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
References: <1245247057.3312.2.camel@myhost> <1245248241.4870.12.camel@subratamodak.linux.ibm.com> <20090617152802.GB6042@elte.hu>
In-Reply-To: <20090617152802.GB6042@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906171812.51478.elendil@planet.nl>
X-OriginalArrivalTime: 17 Jun 2009 16:12:52.0056 (UTC) FILETIME=[77186580:01C9EF66]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 June 2009, Ingo Molnar wrote:
> Ah, and you fixed in what a superior way: you improved the code in
> the process :-) This is how warnings should be fixed really.

Hmm. Did you also see Pavel's reply to that patch [1]:
! But that's a bug to be fixed, I'd say? ... actually I believe you are
! introducing a bug here. Yes, old code would put random numbers in
! loops_per_jiffy_ref for !CPUFREQ_CONST_LOOPS, but you are introducing
! oops there.

Was his comment incorrect?

Cheers,
FJP

[1] http://lkml.org/lkml/2009/5/24/159
