Return-Path: <linux-kernel-owner+w=401wt.eu-S1752190AbYKLGNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbYKLGNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 01:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbYKLGNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 01:13:15 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46017 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbYKLGNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 01:13:15 -0500
Date: Wed, 12 Nov 2008 15:12:33 +0900
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
Message-Id: <20081112151233.0ec8dc44.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <491A7345.4090500@linux.vnet.ibm.com>
References: <20081111123314.6566.54133.sendpatchset@balbir-laptop>
	<20081111123417.6566.52629.sendpatchset@balbir-laptop>
	<20081112140236.46448b47.kamezawa.hiroyu@jp.fujitsu.com>
	<491A6E71.5010307@linux.vnet.ibm.com>
	<20081112150126.46ac6042.kamezawa.hiroyu@jp.fujitsu.com>
	<491A7345.4090500@linux.vnet.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 11:40:13 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> I think of it as easy to update - as in the modularity, you can plug out
> hierarchical reclaim easily and implement your own hierarchical reclaim.
> 
When I do so, I'll rewrite all, again.

> > Can you make this code iterative rather than recursive ?
> > 
> > I don't like this kind of recursive call with complexed lock/unlock.
> 
> I tried an iterative version, which ended up looking very ugly. I think the
> recursive version is easier to understand. What we do is a DFS walk - pretty
> standard algorithm.
> 
But recursive one is not good for search-and-try algorithm.

Thanks,
-Kame

