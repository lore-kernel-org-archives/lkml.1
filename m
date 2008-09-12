Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbYILEeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbYILEeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 00:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYILEeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 00:34:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35568 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbYILEeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 00:34:03 -0400
Date: Fri, 12 Sep 2008 13:36:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, "xemul@openvz.org" <xemul@openvz.org>,
       "hugh@veritas.com" <hugh@veritas.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [RFC] [PATCH 3/9]  memcg: move_account between groups
Message-Id: <20080912133601.1d3d82a6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080911201451.6aecd29a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080911200855.94d33d3b.kamezawa.hiroyu@jp.fujitsu.com>
	<20080911201451.6aecd29a.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008 20:14:51 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> +	if (try_lock_page_cgroup(page))
> +		return ret;
Here is buggy and should be !try_lock_page_cgroup().
and uncharge should be called.

> +
> +	if (page_get_page_cgroup(page) != pc)
> +		goto out;
uncharge should be called.

Updated version will appear in the next week.

Thanks,
-Kame

