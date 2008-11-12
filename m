Return-Path: <linux-kernel-owner+w=401wt.eu-S1752013AbYKLGeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbYKLGeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 01:34:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYKLGdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 01:33:54 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46855 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbYKLGdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 01:33:54 -0500
Date: Wed, 12 Nov 2008 15:33:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][mm] [PATCH 3/4] Memory cgroup hierarchical reclaim (v3)
Message-Id: <20081112153314.a7162192.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <491A7637.3050402@linux.vnet.ibm.com>
References: <20081111123314.6566.54133.sendpatchset@balbir-laptop>
	<20081111123417.6566.52629.sendpatchset@balbir-laptop>
	<20081112140236.46448b47.kamezawa.hiroyu@jp.fujitsu.com>
	<491A6E71.5010307@linux.vnet.ibm.com>
	<20081112150126.46ac6042.kamezawa.hiroyu@jp.fujitsu.com>
	<491A7345.4090500@linux.vnet.ibm.com>
	<20081112151233.0ec8dc44.kamezawa.hiroyu@jp.fujitsu.com>
	<491A7637.3050402@linux.vnet.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 11:52:47 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Wed, 12 Nov 2008 11:40:13 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> >> I think of it as easy to update - as in the modularity, you can plug out
> >> hierarchical reclaim easily and implement your own hierarchical reclaim.
> >>
> > When I do so, I'll rewrite all, again.
> > 
> 
> I don't intend to ask you to rewrite it, rewrite all, I meant you as in a
> generic person. With hierarchy we will need weighted reclaim, which I'll add in
> later.
> 
> >>> Can you make this code iterative rather than recursive ?
> >>>
> >>> I don't like this kind of recursive call with complexed lock/unlock.
> >> I tried an iterative version, which ended up looking very ugly. I think the
> >> recursive version is easier to understand. What we do is a DFS walk - pretty
> >> standard algorithm.
> >>
> > But recursive one is not good for search-and-try algorithm.
> 
> OK, I'll post the iterative algorithm, but it is going to be dirty :)
> 
Ah, thanks. I think maybe you're right that ittrative one is dirty.
I want to compare before going further. 
Thank you for your patience.

Regards,
-Kame

