Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbXFOSDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbXFOSDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbXFOSCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:02:50 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:2095 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbXFOSCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:02:48 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2007 14:02:48 EDT
X-IronPort-AV: i="4.16,425,1175497200"; 
   d="scan'208"; a="379821429:sNHT55673460"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Question about scheduling in 2.4.20
Date: Fri, 15 Jun 2007 10:52:24 -0700
Message-ID: <FA6FB5FA4DA6BF4386D129273B2E3EC301EDDE0F@xmb-sjc-214.amer.cisco.com>
In-Reply-To: <FA6FB5FA4DA6BF4386D129273B2E3EC301EDDDFE@xmb-sjc-214.amer.cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Question about scheduling in 2.4.20
Thread-Index: AceupcG1QuTxs+DsSwmYJaWKbIxNbwAz6cFw
References: <FA6FB5FA4DA6BF4386D129273B2E3EC301EDDDFE@xmb-sjc-214.amer.cisco.com>
From: "Ravinandan Arakali \(rarakali\)" <rarakali@cisco.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 Jun 2007 17:53:02.0327 (UTC) FILETIME=[04B43870:01C7AF76]
Authentication-Results: sj-dkim-2; header.From=rarakali@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I notice with our version, it's running 2.4.20 but has the O(1)
scheduling patch.

Specifically, we see that the process sleeps inside an ioctl for more
than 3 secs, 
wakes up, comes out of the blocking call and is immediately scheduled
out. After 
this, it's not scheduled for next 4 secs. 
Does this look like a fairness/starvation issue ?

Thanks,
Ravi 

-----Original Message-----
From: Ravinandan Arakali (rarakali) 
Sent: Thursday, June 14, 2007 10:02 AM
To: Linux Kernel
Subject: Question about scheduling in 2.4.20

Hi,
I have a question about scheduling latencies in 2.4.20. We are seeing
that our process (started with default priority, normal fork, exec) is
not scheduled on the CPU for 4 seconds (from our kernel traces). Is that
possible under heavy load ? We believe the process is still alive but I
wanted to know if anybody has an idea from experimental results, about
the worst case scenario.
>From syscall trace, we also know that the process is not inside any
blocking system call.

Thanks,
Ravi 
