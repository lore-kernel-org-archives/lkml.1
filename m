Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbYKBGY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbYKBGY5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 01:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYKBGYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 01:24:47 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51051 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbYKBGYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 01:24:47 -0500
Date: Sun, 2 Nov 2008 15:24:12 +0900
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
Message-Id: <20081102152412.2af29a1b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <490D42C7.4000301@linux.vnet.ibm.com>
References: <20081101184812.2575.68112.sendpatchset@balbir-laptop>
	<20081101184902.2575.11443.sendpatchset@balbir-laptop>
	<20081102143817.99edca6d.kamezawa.hiroyu@jp.fujitsu.com>
	<490D42C7.4000301@linux.vnet.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Nov 2008 11:33:51 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Sun, 02 Nov 2008 00:19:02 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> >> Don't enable multiple hierarchy support by default. This patch introduces
> >> a features element that can be set to enable the nested depth hierarchy
> >> feature. This feature can only be enabled when there is just one cgroup
> >> (the root cgroup).
> >>
> > Why the flag is for the whole system ?
> > flag-per-subtree is of no use ?
> 
> Flag per subtree might not be useful, since we charge all the way up to root,
Ah, what I said is "How about enabling/disabling hierarhcy support per subtree ?"
Sorry for bad text.

like this.
  - you can set hierarchy mode of a cgroup turned on/off when...
    * you don't have any tasks under it && it doesn't have any child cgroup.

Thanks,
-Kame

