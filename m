Return-Path: <linux-kernel-owner+w=401wt.eu-S935309AbZLGPZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935309AbZLGPZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935264AbZLGPZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:25:12 -0500
Received: from snt0-omc1-s37.snt0.hotmail.com ([65.55.90.48]:15482 "EHLO
	snt0-omc1-s37.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932639AbZLGPZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:25:11 -0500
X-Originating-IP: [94.195.177.167]
X-Originating-Email: [johnkyr83@hotmail.com]
Message-ID: <SNT111-DS1957B574BA05A48FEDBFF0A7900@phx.gbl>
From: "Ioannis Kyriakopoulos" <johnkyr83@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: timer interrupt stucks using tickless kernel
Date: Mon, 7 Dec 2009 15:25:12 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acp3UXhD1R6mbV5yTGykTs+HAU6bQg==
Content-Language: en-gb
X-OriginalArrivalTime: 07 Dec 2009 15:25:18.0259 (UTC) FILETIME=[7B904830:01CA7751]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have configured my kernel (2.6.31.6) so that I get periodic ticks from
the timer interrupt (i.e. tickless is not configured) with a rate determined
by the HZ value. I've also checked the "high resolution timer support"
and also SMP support. The posblem is that the timer is getting incremented 
very slowly (way slower than the HZ value), just like it would be if the 
kernel was tickless. Is there an explanation for that? How can I get
periodic
timer ticks?

AFAI understand, the HPET timer is used through the IO-APIC controller to
trigger the processors (N.B. if the "High Resolution Timer Support" option
wasn't checked, the timer used would  be PIT, right?) and each processor's
LAPIC timer is used for time keeping. Please correct me if I am wrong.

Another question is how the LAPIC timner's rate is determined? In my case,
it seams that an interurpt by LAPIC timer is generated very appoximately
0.25 sec (that is HZ which is 1000 * 4) but I can't understand why.

Thanks in advance.

