Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbZGBGhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbZGBGhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 02:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbZGBGhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 02:37:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34350 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbZGBGhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 02:37:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 2 Jul 2009 15:35:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>
Subject: Re: [PATCH] memcg: fix cgroup rmdir hang v4
Message-Id: <20090702153545.15d313d6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090702063002.GO11273@balbir.in.ibm.com>
References: <20090630180109.f137c10e.kamezawa.hiroyu@jp.fujitsu.com>
	<20090701104747.afdcc6c7.kamezawa.hiroyu@jp.fujitsu.com>
	<20090702063002.GO11273@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jul 2009 12:00:05 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-07-01 10:47:47]:

> > -static void cgroup_wakeup_rmdir_waiters(const struct cgroup *cgrp)
> > +static void cgroup_wakeup_rmdir_waiter(struct cgroup *cgrp)
> 
> Should the function explictly mention rmdir?
For now, yes. this is only for rmdir.

> Also something like
> release_rmdir should be called release_and_wakeup to make the action
> clearer.
> 
Hm, I don't think this name is too bad. Comment is enough and if we have to
change the behavior of cgroup-internal work, we have to rename this again.
This name is not too much explaining but showing enough information.


> Looks good to me otherwise and clean.
> 
Thank you.

Regards,
-Kame

