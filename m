Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbXHJGZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbXHJGZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 02:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbXHJGZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 02:25:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46734 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813AbXHJGZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 02:25:41 -0400
Date: Thu, 9 Aug 2007 23:25:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Softlockup detected with 2.6.23-rc2-mm1
Message-Id: <20070809232504.c28a3c93.akpm@linux-foundation.org>
In-Reply-To: <46BC02B9.1000307@linux.vnet.ibm.com>
References: <46BC02B9.1000307@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 11:46:25 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> I get call trace, when the file system stress is run on the
> 2.6.23-rc2-mm1 kernel on a Dual Core AMD Opteron
> (processor 270)
> 
> ============================================\BUG: spinlock bad magic on 
> CPU#1, fsx-linux/19721

Yes, sorry, mm-dirty-balancing-for-tasks.patch had a bug.  Those patches were
removed from 2.6.23-rc2-mm2 - please test that instead.
