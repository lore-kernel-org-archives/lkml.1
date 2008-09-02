Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYIBKBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYIBKBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 06:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYIBKBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 06:01:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33813 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYIBKBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 06:01:35 -0400
Date: Tue, 2 Sep 2008 19:07:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
Message-Id: <20080902190723.841841f0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48BD0E4A.5040502@linux.vnet.ibm.com>
References: <20080831174756.GA25790@balbir.in.ibm.com>
	<200809011656.45190.nickpiggin@yahoo.com.au>
	<20080901161927.a1fe5afc.kamezawa.hiroyu@jp.fujitsu.com>
	<200809011743.42658.nickpiggin@yahoo.com.au>
	<48BD0641.4040705@linux.vnet.ibm.com>
	<20080902190256.1375f593.kamezawa.hiroyu@jp.fujitsu.com>
	<48BD0E4A.5040502@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2008 15:28:34 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Tue, 02 Sep 2008 14:54:17 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> >> Nick Piggin wrote:
> >>> That could be a reasonable solution.  Balbir has other concerns about
> >>> this... so I think it is OK to try the radix tree approach first.
> >> Thanks, Nick!
> >>
> >> Kamezawa-San, I would like to integrate the radix tree patches after review and
> >> some more testing then integrate your patchset on top of it. Do you have any
> >> objections/concerns with the suggested approach?
> >>
> > please show performance number first.
> 
> Yes, that is why said some more testing. I am running lmbench and kernbench on
> it and some other tests, I'll get back with numbers.
> 
A test which is not suffer much from I/O is better.
And please don't worry about my patches. I'll reschedule if yours goes first.

Thanks,
-Kame

