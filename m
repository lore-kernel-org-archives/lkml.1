Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbXCVVWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbXCVVWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 17:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbXCVVWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 17:22:02 -0400
Received: from smtp.osdl.org ([65.172.181.24]:52043 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbXCVVWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 17:22:01 -0400
Date: Thu, 22 Mar 2007 14:21:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cpw@sgi.com (Cliff Wickman)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] cpusets/sched_domain reconciliation
Message-Id: <20070322142152.5f6fa41c.akpm@linux-foundation.org>
In-Reply-To: <4600329B.mailxHGH16L00Y@eag09.americas.sgi.com>
References: <4600329B.mailxHGH16L00Y@eag09.americas.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007 13:14:35 -0600
cpw@sgi.com (Cliff Wickman) wrote:

> This patch reconciles cpusets and sched_domains that get out of sync
> due to disabling and re-enabling of cpu's.

I get three-out-of-three rejects in cpuset.c.  I could fix them, but I
wouldn't be very confident that the result works at runtime.  2.6.20-rc6 was
a long time ago - please, always raise patches against the latest mainline
kernel (the daily git snapshot suffices).

Recursion is a big no-no in kernel.  Is there any way in which it can be
avoided?  Is Dinakar's implementation also recursive?
