Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbXCHHRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbXCHHRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 02:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932837AbXCHHRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 02:17:21 -0500
Received: from mtwmail.mindtree.com.60.200.203.in-addr.arpa ([203.200.60.136]:48680
	"EHLO mailwo11.mindtree.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932819AbXCHHRU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 02:17:20 -0500
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.2826
Content-Class: urn:content-classes:message
Importance: normal
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Locking function (interrupt handler) in the L1/L2 cache
Date: Thu, 8 Mar 2007 12:47:19 +0530
Message-ID: <2C15D00D262B7245B1D8D1799F04D88F04A5874B@mtw01ex01.mindtree.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Locking function (interrupt handler) in the L1/L2 cache
thread-index: AcdhUc8b+CHq1c7cR3CrYGHlULDo8Q==
From: "Parav K Pandit" <parav_pandit@mindtree.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 Mar 2007 07:17:21.0710 (UTC) FILETIME=[D03AACE0:01C76151]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have MPC8548 Linux based firewall which will mostly do packet processing
for 80% time.
So obviously most of the time it will RX and TX packets through gianfar
Ethernet driver.

I want to lock my interrupt handler of this driver in the L1 cache.

1. Are there any kernel APIs to lock any function and data in the L1/L2
cache?

2. How can I use "icbtls" - Instruction Cache Block Touch and Lock Set" for
locking my interrupt handler?

3. Is "icbtls" is the correct instruction at which I am looking at?

4. How do I find end address of the interrupt handler or any other function
and how do we pass it to cache locking instructions? (Because it can happen
that interrupt handler size is more than a cache line, not aligned etc)?

5. Can we enhance request_irq() function to take an additional parameter to
lock the interrupt handler in the cache?

I understand that if my interrupt handler is going to be called most of the
time then it is very likely to happen that OS will not flush the same, but
there is no guarantee for it.

Regards,
Parav Pandit


DISCLAIMER:
This message (including attachment if any) is confidential and may be privileged. Before opening attachments please check them for viruses and defects. MindTree Consulting Limited (MindTree) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within MindTree or outside. If you have received this message by mistake please notify the sender by return  e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited.  Please note that e-mails are susceptible to change and MindTree shall not be liable for any improper, untimely or incomplete transmission.
