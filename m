Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbXFOItf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbXFOItf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 04:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbXFOIt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 04:49:27 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:11719 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbXFOIt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 04:49:26 -0400
Date: Fri, 15 Jun 2007 10:49:25 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Valdis.Kletnieks@vt.edu
cc: holzheu@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, akpm@osdl.org, gregkh@suse.de,
       mtk-manpages@gmx.net, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [RFC/PATCH] Documentation of kernel messages
In-Reply-To: <17542.1181753455@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0706151047570.32724@fbirervta.pbzchgretzou.qr>
References: <1181747217.29512.9.camel@localhost.localdomain>
 <17542.1181753455@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 13 2007 12:50, Valdis.Kletnieks@vt.edu wrote:
>> In general we think, that also for Linux it is a good thing to have
>> documentation for the most important kernel/driver messages. Even
>> kernel hackers not always are aware of the meaning of kernel messages
>> for components, which they don't know in detail. Most of the messages
>> are self explaining but sometimes you get something like "Clocksource
>> tsc unstable (delta = 7304132729 ns)" and you wonder if your system is
>> going to explode.

I suppose no. If it is going to explode, it will tell you :-)

/* fs/super.c */
printk("VFS: Busy inodes after unmount of %s. "
       "Self-destruct in 5 seconds.  Have a nice day...\n",
       sb->s_id);

>This is probably best addressed by cleaning up the actual messages so they're
>a bit more informative.


	Jan
-- 
