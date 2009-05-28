Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbZE1INM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbZE1INM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbZE1IM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:12:56 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:40435 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbZE1IMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:12:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18974.18303.129184.151934@cargo.ozlabs.ibm.com>
Date: Thu, 28 May 2009 18:12:47 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3] perf_counter: Fix races in attaching counters to
   tasks and exiting
In-Reply-To: <18973.52627.412425.708834@cargo.ozlabs.ibm.com>
References: <18973.52627.412425.708834@cargo.ozlabs.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Hold off on this patch for the moment.  I'm getting some task_struct
ref counts going negative with it.

Paul.
