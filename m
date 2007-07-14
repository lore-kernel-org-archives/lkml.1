Return-Path: <linux-kernel-owner+w=401wt.eu-S1760262AbXGNJRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262AbXGNJRe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 05:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbXGNJRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 05:17:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34978 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbXGNJRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 05:17:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Sat, 14 Jul 2007 11:24:56 +0200
User-Agent: KMail/1.9.5
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <Pine.LNX.4.64.0707140017560.25614@asgard.lang.hm> <Pine.LNX.4.64.0707140128210.25614@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707140128210.25614@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707141124.57935.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 14 July 2007 10:33, david@lang.hm wrote:
> by the way, a data point on kernel sizes
> 
> -rw-r--r-- 1 root root  864648 Jul 14 00:53 vmlinuz.2.6.22.1.hibernate
> -rw-r--r-- 1 root root  659496 Jul 14 01:17 vmlinuz.2.6.22.1.hibernate.stripped
> -rw-r--r-- 1 root root 3948168 Jul 14 01:10 vmlinuz.2.6.22.1.running
> 
> the running one matches the config I'm running on my home server, the 
> hibernate is a pretty stripped down version, and the stripped is close to 
> a minimum (including turning off printk and BUG()). All three are with all 
> drivers built-in, no module support.
> 
> this is on a amd64 64 bit system
> 
> configs are available if anyone cares, the point is how much smaller a 
> kernel could be if it doesn't need all the stuff that you put in your main 
> kernel. In my case this includes not enabling the 3-ware card that holds 
> my 12-disk raid array, instead the hibernate image would be stored on one 
> of the scsi drives attached to the adaptec 78xx card.
> 
> I expect that on a normal desktop/laptop with more features (like sound) 
> the savings could be even more significant

But the kernel needs some data to work too (a 'struct page' for each memory
page etc.).

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
