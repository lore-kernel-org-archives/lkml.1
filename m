Return-Path: <linux-kernel-owner+w=401wt.eu-S970555AbXHMU6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970555AbXHMU6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970226AbXHMU4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:56:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37715 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S970024AbXHMU4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:56:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Voegtle <tv@lio96.de>
Subject: Re: 2.6.23-rc2 swsusp, suddenly increased uptime
Date: Mon, 13 Aug 2007 23:06:26 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.63.0708122137130.25343@er-systems.de>
In-Reply-To: <Pine.LNX.4.63.0708122137130.25343@er-systems.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708132306.27587.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 12 August 2007 21:39, Thomas Voegtle wrote:
> 
> Hi,
> 
> today I saw this (output from my suspend script):
> 
> -> woke up at Sun Aug 12 11:39:17 CEST 2007
> -> uptime is
>  11:39am  up 8 days  0:41,  10 users,  load average: 26.12, 6.35, 2.17
> 
> 
> Then I did a software suspend. After waking up, I saw this:
> 
> 
> -> woke up at Sun Aug 12 14:41:56 CEST 2007
> -> uptime is
>   2:41pm  up 44 days  9:11,  12 users,  load average: 35.17, 9.17, 3.33

Can you please boot the kernel in the minimal configuration (init=/bin/bash)
and try to hibernate, ie.

# mount /proc
# mount /sys
# swapon -a
# echo disk > /sys/power/state

Also, please check if anything changes if you do

# echo shutdown > /sys/power/disk

before the last command above.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
