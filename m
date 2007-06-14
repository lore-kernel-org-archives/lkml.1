Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbXFNRCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbXFNRCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbXFNRCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:02:45 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:9779 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbXFNRCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:02:44 -0400
X-IronPort-AV: i="4.16,421,1175497200"; 
   d="scan'208"; a="494201752:sNHT40734418"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Question about scheduling in 2.4.20
Date: Thu, 14 Jun 2007 10:02:14 -0700
Message-ID: <FA6FB5FA4DA6BF4386D129273B2E3EC301EDDDFE@xmb-sjc-214.amer.cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Question about scheduling in 2.4.20
Thread-Index: AceupcG1QuTxs+DsSwmYJaWKbIxNbw==
From: "Ravinandan Arakali \(rarakali\)" <rarakali@cisco.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 Jun 2007 17:02:42.0342 (UTC) FILETIME=[D23D5460:01C7AEA5]
Authentication-Results: sj-dkim-3; header.From=rarakali@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have a question about scheduling latencies in 2.4.20. We are seeing
that our
process (started with default priority, normal fork, exec) is not
scheduled
on the CPU for 4 seconds (from our kernel traces). Is that possible
under
heavy load ? We believe the process is still alive but I wanted to know
if
anybody has an idea from experimental results, about the worst case
scenario.
>From syscall trace, we also know that the process is not inside any
blocking
system call.

Thanks,
Ravi 
