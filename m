Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbXIQJlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbXIQJlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbXIQJl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 05:41:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2147 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753478AbXIQJlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 05:41:25 -0400
Date: Sun, 9 Sep 2007 11:18:56 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Nicolas Capit <nicolas.capit@imag.fr>
Cc: linux-kernel@vger.kernel.org, pj@sgi.com, Simon Derr <Simon.Derr@bull.net>
Subject: Re: cpuset trouble after hibernate
Message-ID: <20070909111856.GA4610@ucw.cz>
References: <20070908204438.3bf03d85@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070908204438.3bf03d85@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This is my situation:
>   - I mounted the pseudo cpuset filesystem into /dev/cpuset
>   - I created a cpuset named oar with my 2 cpus
> 
> cat /dev/cpuset/oar/cpus 
> 0-1
> 
>   - Then I hibernate my computer with 'echo -n "disk" >/sys/power/state'
>   - After reboot:
> 
> cat /dev/cpuset/oar/cpus 
> 0
> 
> Why did I lost a cpu?
> Is this a normal behavior???

One of the cpus was unplugged during suspend... perhaps some
save/restore is needed during hotplug/unplug?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
