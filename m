Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbYDKD31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbYDKD31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 23:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYDKD3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 23:29:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52863 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbYDKD3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 23:29:16 -0400
Date: Fri, 11 Apr 2008 12:33:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm] Add an owner to the mm_struct (v9)
Message-Id: <20080411123339.89aea319.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080410091602.4472.32172.sendpatchset@localhost.localdomain>
References: <20080410091602.4472.32172.sendpatchset@localhost.localdomain>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

maybe I don't undestand correctlly...

On Thu, 10 Apr 2008 14:46:02 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

>  
> +config MM_OWNER
> +	bool
> +
no default is ok here  ? what value will this have if not selected ?
I'm sorry if I misunderstand Kconfig.


> +	/*
> +	 * Search through everything else. We should not get
> +	 * here often
> +	 */
> +	do_each_thread(g, c) {
> +		if (c->mm == mm)
> +			goto assign_new_owner;
> +	} while_each_thread(g, c);
> +

Again, do_each_thread() is suitable here ?
for_each_process() ?

Thanks,
-Kame

