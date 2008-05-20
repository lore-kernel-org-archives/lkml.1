Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbYETKDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbYETKDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765033AbYETKBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:01:00 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2883 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765674AbYETKA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:00:59 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andy Whitcroft <apw@shadowen.org>, Mel Gorman <mel@csn.ul.ie>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] panics booting NUMA SPARSEMEM on x86_32 NUMA 
Message-ID: <exportbomb.1211277639@pinky>
Date: Tue, 20 May 2008 11:00:57 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have been seeing panics booting NUMA SPARSEMEM kernels on x86_32
hardware, while trying to allocate node local memory in early boot.
These are caused by a miss-allocation of the node pgdat structures when
numa remap is disabled.

Following this email are two patches, the first reenables numa remap for
SPARSEMEM as the underlying bug has now been fixed.  The second hardens
the pgdat allocation in the face of there being no numa remap for a
particular node (which may still occur).

-apw
