Return-Path: <linux-kernel-owner+w=401wt.eu-S1758622AbYBAJxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbYBAJxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbYBAJxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:53:18 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:7564 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbYBAJxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:53:16 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <200802011053.107168490@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/12] GBPAGES patchkit for 2.6.25 v3
Date: Fri,  1 Feb 2008 10:53:13 +0100 (CET)
X-OriginalArrivalTime: 01 Feb 2008 09:46:55.0952 (UTC) FILETIME=[619CD500:01C864B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchkit implements support for the 1GB pages of AMD Fam10h CPUs 
in the kernel direct mapping. 

Change to previous versions:
- Incorporated feedback from Thomas Gleixner
- Switch direct mapping setup over to set_pte() / pte_pfn()
- Split up patches some more

Includes one not strictly required cleanup patch now (the last one) 

I believe this patchkit is ready for the 2.6.25 merge.

-Andi
