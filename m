Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752351AbYLRLQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbYLRLQS (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 06:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYLRLPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 06:15:43 -0500
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:54850 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbYLRLPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 06:15:41 -0500
Message-ID: <494A30DA.5030605@in.ibm.com>
Date: Thu, 18 Dec 2008 16:45:38 +0530
From: Sharyathi Nagesh <sharyath@in.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>, LKML <linux-kernel@vger.kernel.org>
CC: Paul Menage <menage@google.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        balbir <balbir@linux.vnet.ibm.com>,
        "Rishikesh K. Rajak" <risrajak@in.ibm.com>, akpm@linux-foundation.org
Subject: Re: Error with cgroups: "unused subsystem ns"
References: <4948D3C4.9060900@in.ibm.com> <20081218010841.GA17385@hallyn.com>
In-Reply-To: <20081218010841.GA17385@hallyn.com>
Content-Type: multipart/mixed;
 boundary="------------080109060701060504060109"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080109060701060504060109
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Serge
> 
> Resend the patch to lkml.  Assuming you are talking about commit id
> 93af30a60055a83a00188ae04b88bbd9b4e1489a, go ahead and add my
> Acked-by.
Yes it is the same patch. I am attaching the patch for 2.6.28-rc8 let me 
know: when this can accepted into main line?

> Converting it to a pr_debug() might be another thing to consider, but
> I'm not sure anyone wants these messages.
> 
> -serge

Thanks
Yeehaw




--------------080109060701060504060109
Content-Type: text/x-diff;
 name="unused_subsystem_ns.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="unused_subsystem_ns.patch"

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Sharyathi Nagesh <sharyathi@in.ibm.com>

Acked-by: Serge E. Hallyn <serge@hallyn.com>
-----------------


Index: linux-2.6.28-rc8/kernel/cgroup.c
===================================================================
--- linux-2.6.28-rc8.orig/kernel/cgroup.c	2008-12-11 04:41:51.000000000 +0530
+++ linux-2.6.28-rc8/kernel/cgroup.c	2008-12-18 21:55:58.000000000 +0530
@@ -2934,9 +2934,6 @@
  again:
 	root = subsys->root;
 	if (root == &rootnode) {
-		printk(KERN_INFO
-		       "Not cloning cgroup for unused subsystem %s\n",
-		       subsys->name);
 		mutex_unlock(&cgroup_mutex);
 		return 0;
 	}

--------------080109060701060504060109--
