Return-Path: <linux-kernel-owner+w=401wt.eu-S935428AbYBHUFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935428AbYBHUFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935085AbYBHUEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:04:39 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:19015 "EHLO
	outbound5-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935058AbYBHUEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:04:36 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
Message-ID: <47ACB56A.1030407@amd.com>
Date: Fri, 08 Feb 2008 15:02:50 -0500
From: "Barry Kasindorf" <barry.kasindorf@amd.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
cc: barry.kasindorf@amd.com
Subject: [PATCH 0/3] AMD Family10h IBS support for oProfile driver
X-OriginalArrivalTime: 08 Feb 2008 20:02:50.0609 (UTC)
 FILETIME=[95323E10:01C86A8D]
X-WSS-ID: 6BB26AE70QK10954154-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>

This patchset supports the new IBS profiling hardware available in the latest AMD CPUs in the oProfile driver.
---

These new AMD processors CPUs support Instruction Based Sampling (IBS). See

	 Instruction-Based Sampling: A New Performance Analysis Technique
          for AMD Family 10h Processors, November 19, 2007
          http://developer.amd.com/assets/AMD_IBS_paper_EN.pdf

for more information about IBS.

IBS support requires changes to the oProfile driver to gather this information and initialize the new MSRs associated 
with these new features.

This patch adds 2 new types of Profiling samples IBS_FETCH and IBS_OP to the per CPU buffers and the event buffers of 
the oProfile driver.

It also adds new control entries to /dev/oprofile to control IBS sampling.

These changes are backward compatible with the previous PMC only version of the driver, and a separate patch is 
available to oProfile 0.9.3 to use this new data.

These changes have been extensively tested at AMD on Family10h systems.

Barry Kasindorf barry.kasindorf@amd.com





