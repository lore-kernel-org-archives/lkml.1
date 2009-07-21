Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZGUAFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZGUAFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 20:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbZGUAFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 20:05:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53860 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbZGUAFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 20:05:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 21 Jul 2009 09:03:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/5] Memory controller soft limit patches (v9)
Message-Id: <20090721090317.786141e9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090720154859.GI24157@balbir.in.ibm.com>
References: <20090710125950.5610.99139.sendpatchset@balbir-laptop>
	<20090720154859.GI24157@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009 21:18:59 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Balbir Singh <balbir@linux.vnet.ibm.com> [2009-07-10 18:29:50]:
> 
> > 
> > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > 
> > New Feature: Soft limits for memory resource controller.
> > 
> > Here is v9 of the new soft limit implementation. Soft limits is a new feature
> > for the memory resource controller, something similar has existed in the
> > group scheduler in the form of shares. The CPU controllers interpretation
> > of shares is very different though. 
> > 
> > Soft limits are the most useful feature to have for environments where
> > the administrator wants to overcommit the system, such that only on memory
> > contention do the limits become active. The current soft limits implementation
> > provides a soft_limit_in_bytes interface for the memory controller and not
> > for memory+swap controller. The implementation maintains an RB-Tree of groups
> > that exceed their soft limit and starts reclaiming from the group that
> > exceeds this limit by the maximum amount.
> > 
> > v9 attempts to address several review comments for v8 by Kamezawa, including
> > moving over to an event based approach for soft limit rb tree management,
> > simplification of data structure names and many others. Comments not
> > addressed have been answered via email or I've added comments in the code.
> > 
> > TODOs
> > 
> > 1. The current implementation maintains the delta from the soft limit
> >    and pushes back groups to their soft limits, a ratio of delta/soft_limit
> >    might be more useful
> > 
> 
> 
> Hi, Andrew,
> 
> Could you please pick up this patchset for testing in -mm, both
> Kamezawa-San and Kosaki-San have looked at the patches. I think they
> are ready for testing in mmotm.
> 
ok, plz go. But please consider to rewrite res_coutner related part in more
generic style, allowing mulitple threshold & callbacks without overheads.

Thanks,
-Kame


