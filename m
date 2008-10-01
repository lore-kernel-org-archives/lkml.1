Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbYJAF0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbYJAF0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 01:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbYJAF0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 01:26:33 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42430 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYJAF0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 01:26:32 -0400
Date: Wed, 1 Oct 2008 14:32:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 9/12] memcg allocate all page_cgroup at boot
Message-Id: <20081001143242.1b44de24.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081001140748.637b9831.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com>
	<20080925153206.281243dc.kamezawa.hiroyu@jp.fujitsu.com>
	<48E2F6A9.9010607@linux.vnet.ibm.com>
	<20081001140748.637b9831.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008 14:07:48 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > Can we make this patch indepedent of the flags changes and push it in ASAP.
> > 
> Need much work....Hmm..rewrite all again ? 
> 

BTW, do you have good idea to modify flag bit without affecting LOCK bit on
page_cgroup->flags ?

At least, we'll have to set ACTIVE/INACTIVE/UNEVICTABLE flags dynamically.
take lock_page_cgroup() always ?
__mem_cgroup_move_lists() will have some amount of changes. And we should
check dead lock again.

Thanks,
-Kame

