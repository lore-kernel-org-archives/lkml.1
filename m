Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbYLSRYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbYLSRYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 12:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbYLSRYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 12:24:12 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:36713 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbYLSRYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 12:24:11 -0500
Message-ID: <494BD73E.6040201@in.ibm.com>
Date: Fri, 19 Dec 2008 22:47:50 +0530
From: Sharyathi Nagesh <sharyath@in.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: serge@hallyn.com, linux-kernel@vger.kernel.org, menage@google.com,
       adobriyan@gmail.com, balbir@linux.vnet.ibm.com, risrajak@in.ibm.com
Subject: Re: Error with cgroups: "unused subsystem ns"
References: <4948D3C4.9060900@in.ibm.com> <20081218010841.GA17385@hallyn.com> <494A30DA.5030605@in.ibm.com> <20081218111255.3d95bd1c.akpm@linux-foundation.org>
In-Reply-To: <20081218111255.3d95bd1c.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------040003040605090507060002"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040003040605090507060002
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> 
> I'm unsure waht to make of this.  It has no changelog.  It appears to have
> been authored by yourself, although it's unclear why it has Alexey's
> signoff as well.

This patch is originally from Alexy I have just ported it into latest 
kernel mainline
Thanks
Yeehaw



--------------040003040605090507060002
Content-Type: text/x-diff;
 name="unused_subsystem_ns.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="unused_subsystem_ns.patch"

This patch removes spurious warning messages that are thrown into 
the console during cgroup operations. 

-----------------
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

--------------040003040605090507060002--
