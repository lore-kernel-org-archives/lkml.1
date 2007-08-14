Return-Path: <linux-kernel-owner+w=401wt.eu-S935373AbXHNULk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935373AbXHNULk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 16:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbXHNULc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 16:11:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55829 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754273AbXHNULb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 16:11:31 -0400
Date: Tue, 14 Aug 2007 13:05:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: xemul@openvz.org
Cc: devel@openvz.org, linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       oleg@tv-sign.ru, sukadev@us.ibm.com
Subject: Re: [PATCH 5/20] Introduce struct upid
Message-Id: <20070814130558.4b5e5e3f.akpm@linux-foundation.org>
In-Reply-To: <46BC506F.mailGJ711PNHE@openvz.org>
References: <46BC506F.mailGJ711PNHE@openvz.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 15:47:59 +0400
xemul@openvz.org wrote:

>  struct pid
>  {
>  	atomic_t count;
> @@ -50,6 +50,8 @@ struct pid
>  	/* lists of tasks that use this pid */
>  	struct hlist_head tasks[PIDTYPE_MAX];
>  	struct rcu_head rcu;
> +	int level;
> +	struct upid numbers[1];

You can make this have size [0] now.  It's a gcc extension and
is used elsewhere in the kernel.
