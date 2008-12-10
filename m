Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbYLJCJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbYLJCJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 21:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbYLJCJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 21:09:08 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47570 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYLJCJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 21:09:07 -0500
Date: Wed, 10 Dec 2008 11:08:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/6] memcg: fix pre_destory handler
Message-Id: <20081210110811.652311a7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081209200647.a1fa76a9.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081209200213.0e2128c1.kamezawa.hiroyu@jp.fujitsu.com>
	<20081209200647.a1fa76a9.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2008 20:06:47 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> @@ -98,6 +98,8 @@ enum {
>  	CGRP_RELEASABLE,
>  	/* Control Group requires release notifications to userspace */
>  	CGRP_NOTIFY_ON_RELEASE,
> +	/* Control Group is preparing for death */
> +	CGRP_PRE_REMOVAL,
>  };
I'll rename CGRP_PRE_REMOVAL to be CGRP_TRY_REMOVE>

Thanks,
-Kame

