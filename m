Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbZLJAWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbZLJAWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759010AbZLJAWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:22:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758931AbZLJAWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:22:09 -0500
Date: Wed, 9 Dec 2009 16:21:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] [TRIVIAL] memcg: fix memory.memsw.usage_in_bytes for
 root cgroup
Message-Id: <20091209162109.567ff5fa.akpm@linux-foundation.org>
In-Reply-To: <20091210085929.56c63eb2.kamezawa.hiroyu@jp.fujitsu.com>
References: <1260373738-17179-1-git-send-email-kirill@shutemov.name>
	<20091210085929.56c63eb2.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009 08:59:29 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed,  9 Dec 2009 17:48:58 +0200
> "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> 
> > We really want to take MEM_CGROUP_STAT_SWAPOUT into account.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> > Cc: stable@kernel.org
> 
> Thanks.
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 

Is this bug sufficiently serious to justify a -stable backport?

If so, why?

Thanks.
