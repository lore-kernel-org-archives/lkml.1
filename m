Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYCWFoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYCWFoU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 01:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYCWFoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 01:44:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795AbYCWFoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 01:44:13 -0400
Date: Sat, 22 Mar 2008 22:43:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Carlos R. Mafra" <crmafra2@gmail.com>, linux-kernel@vger.kernel.org,
       riel@redhat.com, rjw@sisk.pl
Subject: Re: 103 sec. latency: sync_page() with TASK_UNINTERRUPTIBLE (?)
 (bisected)
Message-Id: <20080322224340.bd08981b.akpm@linux-foundation.org>
In-Reply-To: <20080322224143.0e2901cd.akpm@linux-foundation.org>
References: <20080322220134.GA4559@localhost.ift.unesp.br>
	<20080323034725.GA3781@localhost.ift.unesp.br>
	<20080322224143.0e2901cd.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008 22:41:43 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> > If a revert the above commit from the latest git kernel
> > (v2.6.25-rc6-243-g028011e), then I get an very good interactivity
> > while xjed is loading the 380MB file (meaning that I can do other things
> > during the load). Otherwise it takes almost 3 times longer to load,
> > and interactivity is very bad in the meanwhile. I doubled checked it.

hm.

> 
> Thanks, I queued the below reversion.  It would be great if you could
> confirm that this patch does indeed make 2.6.25-rc6 work as well as 2.6.24.

I guess you've already done this.
