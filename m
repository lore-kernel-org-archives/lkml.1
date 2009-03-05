Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZCEXqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZCEXqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbZCEXqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:46:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753488AbZCEXqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:46:23 -0500
Date: Thu, 5 Mar 2009 15:44:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       =?ISO-8859-15?Q?Arve__Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH 0/4] Rework disabling of interrupts during
 suspend-resume
In-Reply-To: <200903012321.40328.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0903051542270.19207@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200903012321.40328.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 1 Mar 2009, Rafael J. Wysocki wrote:
> 
> The following patches modifiy the way in which we handle disabling interrupts
> during suspend and enabling them during resume.  They also change the ordering
> of the core suspend and hibernation code.

Side note - I've tested them on the EeePC that had trouble resuming due to 
interrupt timings, and it suspends and resumes fine with these patches 
(modulo some new X problems, but that's what I get for living with 
Fedora-11 testing).

Of course, it also suspends and resumes without them, since the CPU "cli" 
was sufficient for that machine, and it doesn't have any ACPI issues. But 
it's still an ack that at least nothing breaks that I can tell.

		Linus
