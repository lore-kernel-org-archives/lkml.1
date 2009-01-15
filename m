Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbZAODJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbZAODJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 22:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbZAODJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 22:09:37 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39155 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZAODJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 22:09:37 -0500
Date: Thu, 15 Jan 2009 12:08:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH 5/4] memcg: don't call res_counter_uncharge when
 obsolete
Message-Id: <20090115120829.e1d417e8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090115114846.388781a7.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090113184533.6ffd2af9.nishimura@mxp.nes.nec.co.jp>
	<20090114175121.275ecd59.nishimura@mxp.nes.nec.co.jp>
	<20090114135539.GA21516@balbir.in.ibm.com>
	<20090115114846.388781a7.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 11:48:46 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed, 14 Jan 2009 19:25:39 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > I liked the earlier, EBUSY approach that ensured that parents could
> > not go away if children exist. IMHO, the code has gotten too complex
> > and has too many corner cases. Time to revisit it.
> > 
> It's on my plan. 
> I'll fix this by CSS-ID patch.
> 
> When I recored memcg's CSS-ID to swap_cgroup (not pointer to memcg), 
> we never need memcg's refcnt.
> 
Sorry, ignore this. refcnt in memcg is necessary anyway to prevent reuse of ID.

-Kame

