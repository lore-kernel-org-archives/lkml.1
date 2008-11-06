Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbYKFHbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbYKFHbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYKFHbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:31:00 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51836 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbYKFHa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:30:59 -0500
Date: Thu, 6 Nov 2008 16:30:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [mm] [PATCH 4/4] Memory cgroup hierarchy feature selector
Message-Id: <20081106163021.93f3cbe2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4912951D.60301@linux.vnet.ibm.com>
References: <20081101184812.2575.68112.sendpatchset@balbir-laptop>
	<20081101184902.2575.11443.sendpatchset@balbir-laptop>
	<20081102143817.99edca6d.kamezawa.hiroyu@jp.fujitsu.com>
	<490D42C7.4000301@linux.vnet.ibm.com>
	<20081102152412.2af29a1b.kamezawa.hiroyu@jp.fujitsu.com>
	<4912951D.60301@linux.vnet.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008 12:26:29 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Sun, 02 Nov 2008 11:33:51 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> >> KAMEZAWA Hiroyuki wrote:
> >>> On Sun, 02 Nov 2008 00:19:02 +0530
> >>> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> >>>
> >>>> Don't enable multiple hierarchy support by default. This patch introduces
> >>>> a features element that can be set to enable the nested depth hierarchy
> >>>> feature. This feature can only be enabled when there is just one cgroup
> >>>> (the root cgroup).
> >>>>
> >>> Why the flag is for the whole system ?
> >>> flag-per-subtree is of no use ?
> >> Flag per subtree might not be useful, since we charge all the way up to root,
> > Ah, what I said is "How about enabling/disabling hierarhcy support per subtree ?"
> > Sorry for bad text.
> > 
> > like this.
> >   - you can set hierarchy mode of a cgroup turned on/off when...
> >     * you don't have any tasks under it && it doesn't have any child cgroup.
> 
> I see.. the presence of tasks don't matter, since the root cgroup will always
> have tasks. Presence of child groups does matter.
> 
yes. you're right.

Thanks,
-Kame

