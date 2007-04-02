Return-Path: <linux-kernel-owner+w=401wt.eu-S965635AbXDBSQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965635AbXDBSQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 14:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965646AbXDBSQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 14:16:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1672 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965635AbXDBSQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 14:16:57 -0400
Date: Mon, 2 Apr 2007 13:22:55 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC] Cpu-hotplug: Using the Process Freezer (try2)
Message-ID: <20070402132255.GB6739@ucw.cz>
References: <20070402053457.GA9076@in.ibm.com> <20070402061612.GA7072@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402061612.GA7072@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> i'm wondering about how TASK_UNINTERRUPTIBLE tasks are handled by the 
> freezer: are they assumed frozen immediately, or do we wait until they 
> notice their PF_FREEZING and go into try_to_freeze()? I'd expect 

They have to wait. We need all tasks frozen _with no locks held_.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
