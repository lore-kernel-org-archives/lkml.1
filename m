Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbXJIOi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbXJIOi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 10:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbXJIOit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 10:38:49 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:45522
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752122AbXJIOis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 10:38:48 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/5] RT: scheduler fixes and rt_overload enhancements
To: mingo@elte.hu, linux-rt-users@vger.kernel.org, rostedt@goodmis.org
Cc: kravetz@us.ibm.com, linux-kernel@vger.kernel.org, ghaskins@novell.com,
       pmorreale@novell.com, sdietrich@novell.com
Date: Tue, 09 Oct 2007 10:25:44 -0400
Message-ID: <20071009142044.4941.65189.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The first two patches are from Mike and Steven on LKML, which the rest of my
series is dependent on.  Patch #4 is a resend from earlier.

Series Summary:

1) Send IPI on overload regardless of whether prev is an RT task
2) Set the NEEDS_RESCHED flag on reception of RESCHED_IPI
3) Fix a mistargeted IPI on overload
4) Track which CPUS are in overload for efficiency
5) Track which CPUs are eligible for rebalancing for efficiency

These have been built and boot-tested on a 4-core Intel system.

Regards,
-Greg
