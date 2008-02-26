Return-Path: <linux-kernel-owner+w=401wt.eu-S1761098AbYBZEaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761098AbYBZEaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 23:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757814AbYBZEaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 23:30:13 -0500
Received: from relay2.sgi.com ([192.48.171.30]:57017 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756585AbYBZEaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 23:30:08 -0500
Date: Mon, 25 Feb 2008 22:30:01 -0600
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: lizf@cn.fujitsu.com, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: fix default notify_on_release setting
Message-Id: <20080225223001.3d0352eb.pj@sgi.com>
In-Reply-To: <6599ad830802242222p7d42d2b2ue7c585eae8f3bed@mail.gmail.com>
References: <47C257EB.5060600@cn.fujitsu.com>
	<6599ad830802242222p7d42d2b2ue7c585eae8f3bed@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  @@ -2242,6 +2241,9 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
>         cgrp->root = parent->root;
>         cgrp->top_cgroup = parent->top_cgroup;
>
>  +       if (notify_on_release(parent))
>  +               set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);


Good catch, Li Zefan - thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
