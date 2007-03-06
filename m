Return-Path: <linux-kernel-owner+w=401wt.eu-S1030296AbXCFWBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030296AbXCFWBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 17:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030302AbXCFWBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 17:01:32 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60864 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030296AbXCFWBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 17:01:31 -0500
Date: Tue, 6 Mar 2007 14:00:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelianov <xemul@sw.ru>
Cc: Paul Menage <menage@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, devel@openvz.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       containers@lists.osdl.org, Kirill Korotaev <dev@sw.ru>
Subject: Re: [RFC][PATCH 2/7] RSS controller core
Message-Id: <20070306140036.4e85bd2f.akpm@linux-foundation.org>
In-Reply-To: <45ED80E1.7030406@sw.ru>
References: <45ED7DEC.7010403@sw.ru>
	<45ED80E1.7030406@sw.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Mar 2007 17:55:29 +0300
Pavel Emelianov <xemul@sw.ru> wrote:

> +struct rss_container {
> +	struct res_counter res;
> +	struct list_head page_list;
> +	struct container_subsys_state css;
> +};
> +
> +struct page_container {
> +	struct page *page;
> +	struct rss_container *cnt;
> +	struct list_head list;
> +};

ah.  This looks good.  I'll find a hunk of time to go through this work
and through Paul's patches.  It'd be good to get both patchsets lined
up in -mm within a couple of weeks.  But..

We need to decide whether we want to do per-container memory limitation via
these data structures, or whether we do it via a physical scan of some
software zone, possibly based on Mel's patches.

