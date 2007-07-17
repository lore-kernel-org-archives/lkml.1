Return-Path: <linux-kernel-owner+w=401wt.eu-S932770AbXGQRlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770AbXGQRlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757957AbXGQRk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:40:57 -0400
Received: from mx.treblig.org ([80.68.94.177]:3116 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbXGQRk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:40:56 -0400
Date: Tue, 17 Jul 2007 18:40:44 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: david@lang.hm
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
Message-ID: <20070717174044.GA11212@gallifrey>
References: <200707151433.34625.rjw@sisk.pl> <20070715125855.GA1737@gallifrey> <200707160038.12943.rjw@sisk.pl> <Pine.LNX.4.64.0707151526080.25614@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707151526080.25614@asgard.lang.hm>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 18:39:14 up 74 days, 11:22,  2 users,  load average: 0.98, 0.80, 0.75
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* david@lang.hm (david@lang.hm) wrote:
> On Mon, 16 Jul 2007, Rafael J. Wysocki wrote:

> >Encryption is possible with both the userland hibernation (aka uswsusp) and
> >TuxOnIce (formerly known as suspend2).  Still, I don't consider it as a 
> >"must
> >have" feature for a framework to be generally useful (many users don't use 
> >it
> >anyway).
> 
> he's talking about the main system useing an encrypted device/partition, 
> not the hibernate image being stored encrypted.
> 
> This would require the main system 'forget' the keys when it does the 
> hinbernate and prompt for it again during the wake-up phase.

Indeed - although as I say I really don't know what you would do with
apps using the mounts at that point.   Still it seems like a 
sensible requrest from the security side.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
