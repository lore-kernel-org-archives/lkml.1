Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbZJQSdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbZJQSdX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 14:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZJQSdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 14:33:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44135 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbZJQSdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 14:33:22 -0400
Date: Sat, 17 Oct 2009 20:33:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
Subject: Re: 2.6.32-rc0-git: oops in wireless, iwl3945 related?
Message-ID: <20091017183320.GF16532@elf.ucw.cz>
References: <20090929171249.GB14405@elf.ucw.cz>
 <1254431783.3959.45.camel@johannes.local>
 <1254432469.3959.46.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254432469.3959.46.camel@johannes.local>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-10-01 23:27:49, Johannes Berg wrote:
> On Thu, 2009-10-01 at 23:16 +0200, Johannes Berg wrote:
> 
> > > wlan0: Selected IBSS BSSID 02:18:41:de:3f:02 based on configured SSID
> > > wlan0: Trigger new scan to find an IBSS to join
> > > wlan0: Trigger new scan to find an IBSS to join
> > > wlan0: Creating new IBSS network, BSSID f2:d3:80:82:ed:6a
> > > wlan0: Creating new IBSS network, BSSID 52:17:bf:45:d6:9d
> > > skb_over_panic: text:c07b4113 len:130 put:36 head:e4c3edf0
> > 
> > This entire log is very odd ... can you reproduce this easily? printk
> > timestamps would be useful.
> 
> Kinda looks like a race condition, but it's rather odd. I think there's
> a race condition, so I'm going to submit this patch regardless after
> some testing, but if you want please try the patch below.

Well, the problem is not exactly reproducible... it failed to happen
again. So... thanks and I'll keep my eyes open if it returns. 
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
