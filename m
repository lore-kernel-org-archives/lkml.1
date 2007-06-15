Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbXFOQ4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbXFOQ4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbXFOQ4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:56:18 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:54142 "EHLO
	outbound1-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753177AbXFOQ4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:56:17 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Fri, 15 Jun 2007 18:56:50 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Stephane Eranian" <eranian@hpl.hp.com>
cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: [patch 0/8] 2.6.22-rc3 perfmon2 : IBS implementation for AMD64
Message-ID: <20070614215818.509851000@localhost>
MIME-Version: 1.0
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 15 Jun 2007 16:56:03.0893 (UTC)
 FILETIME=[0F289650:01C7AF6E]
X-WSS-ID: 6A6C1B2C23K500707-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

the following series of patches adds support for Instruction Based
Sampling (IBS) of Barcelona CPUs. IBS is a code profiling mechanism
that enables the processor to select a random instruction fetch or
micro-op after a programmed time interval has expired and record
specific performance information about the operation.

The patches also include a new AMD64 PMU description that dynamically
detects the availability of PMU features of the CPU during
configuration. Thus, there is only one description needed for all AMD
CPU families and models (includes K8, families 10h and above).

The patches are relative to Stephane's 22 patches for 2.6.22-rc3.

Regards,
Robert

--
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com




