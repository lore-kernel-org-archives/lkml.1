Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbXKKWsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbXKKWsq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 17:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbXKKWsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 17:48:39 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:52015 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786AbXKKWsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 17:48:37 -0500
Date: Sun, 11 Nov 2007 23:48:36 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Diego Calleja <diegocg@gmail.com>
cc: Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Improve cgroup printks
Message-ID: <Pine.LNX.4.64.0711112346450.15517@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>When I boot with the 'quiet' parameter, I see on the screen:
>
>[    0.000000] Initializing cgroup subsys cpuset
>[    0.000000] Initializing cgroup subsys cpu
>[   39.036026] Initializing cgroup subsys cpuacct
>[   39.036080] Initializing cgroup subsys debug
>[   39.036118] Initializing cgroup subsys ns
>
>This patch lowers the priority of those messages, adds a "cgroup: " 
>prefix to another couple of printks and kills the useless reference to 
>the source file.

>-	printk(KERN_ERR "Initializing cgroup subsys %s\n", ss->name);
>+	printk("Initializing cgroup subsys %s\n", ss->name);

Every printk should have a loglevel.
