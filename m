Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbXKMLsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbXKMLsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 06:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbXKMLsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 06:48:05 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:62441 "EHLO
	outbound1-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753513AbXKMLsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 06:48:04 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Tue, 13 Nov 2007 12:44:43 +0100
From: "Robert Richter" <robert.richter@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
cc: "LKML" <linux-kernel@vger.kernel.org>
Subject: x86 merge: Keep kernel/cpu for CPU specific code?
Message-ID: <20071113114443.GG18993@erda.amd.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 13 Nov 2007 11:44:43.0868 (UTC)
 FILETIME=[955F39C0:01C825EA]
X-WSS-ID: 6B2751A507S2361007-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

x86 CPU specific code is currently implemented in different ways for
64 and 32 bit. While there are almost no CPU specific files for 64
bit, there is the arch/x86/kernel/cpu/ directory for 32 bit. Is there
already an idea about whether to use kernel/cpu also for 64 bit?

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com


