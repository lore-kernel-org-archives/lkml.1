Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbXGNIkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbXGNIkL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 04:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbXGNIj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 04:39:58 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:46777
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbXGNIj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 04:39:57 -0400
Date: Sat, 14 Jul 2007 01:33:54 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
In-Reply-To: <Pine.LNX.4.64.0707140017560.25614@asgard.lang.hm>
Message-ID: <Pine.LNX.4.64.0707140128210.25614@asgard.lang.hm>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
 <200707131117.38426.rjw@sisk.pl> <Pine.LNX.4.64.0707130211570.25614@asgard.lang.hm>
 <200707131341.35801.rjw@sisk.pl> <Pine.LNX.4.64.0707140017560.25614@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

by the way, a data point on kernel sizes

-rw-r--r-- 1 root root  864648 Jul 14 00:53 vmlinuz.2.6.22.1.hibernate
-rw-r--r-- 1 root root  659496 Jul 14 01:17 vmlinuz.2.6.22.1.hibernate.stripped
-rw-r--r-- 1 root root 3948168 Jul 14 01:10 vmlinuz.2.6.22.1.running

the running one matches the config I'm running on my home server, the 
hibernate is a pretty stripped down version, and the stripped is close to 
a minimum (including turning off printk and BUG()). All three are with all 
drivers built-in, no module support.

this is on a amd64 64 bit system

configs are available if anyone cares, the point is how much smaller a 
kernel could be if it doesn't need all the stuff that you put in your main 
kernel. In my case this includes not enabling the 3-ware card that holds 
my 12-disk raid array, instead the hibernate image would be stored on one 
of the scsi drives attached to the adaptec 78xx card.

I expect that on a normal desktop/laptop with more features (like sound) 
the savings could be even more significant

David Lang
