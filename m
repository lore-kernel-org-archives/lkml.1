Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbZCFGuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbZCFGuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbZCFGsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:48:05 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:56941 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbZCFGsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:48:03 -0500
Date: Fri, 6 Mar 2009 06:47:40 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH 0/4] Rework disabling of interrupts during suspend-resume
Message-ID: <20090306064740.GA20587@silver.sucs.org>
References: <200902221837.49396.rjw@sisk.pl> <200903012321.40328.rjw@sisk.pl> <alpine.LFD.2.00.0903051542270.19207@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903051542270.19207@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 03:44:22PM -0800, Linus Torvalds wrote:
> 
 Side note - I've tested them on the EeePC that had trouble resuming due to 
> interrupt timings, and it suspends and resumes fine with these patches 
> (modulo some new X problems, but that's what I get for living with 
> Fedora-11 testing).

Since you have an EeePC I'm guessing your graphics card is an i9xx of
some variety. The i9xx kernel driver seems to have been recently
reworked so even those people who aren't using GEM yet are seeing issues
here and there (some with VT switching, some with suspend to ram and
others with suspend to disk). I actually don't know if the stuff poping
up is any more than usual but if so I'm hoping most new issues go away
once the dust settles...

-- 
Sitsofe | http://sucs.org/~sits/
