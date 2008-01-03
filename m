Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbYACKmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbYACKmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 05:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYACKmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 05:42:15 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58346 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbYACKmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 05:42:14 -0500
Date: Thu, 3 Jan 2008 11:42:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Moore, Robert" <robert.moore@intel.com>
Subject: Re: [RFC][PATCH 2/7] ACPI: Separate invocations of _GTS and _BFS
	from _PTS and _WAK
Message-ID: <20080103104220.GA1732@elf.ucw.cz>
References: <200712271903.53961.rjw@sisk.pl> <200712271915.17174.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712271915.17174.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-12-27 19:15:16, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The execution of ACPI global control methods _GTS and _BFS is
> currently tied to the preparation to enter a sleep state and to the
> leaving of the sleep state, respectively.  However, these functions
> are called before disabling the nonboot CPUs and after enabling
> them, respectively (in fact, on ACPI 1.0x systems the first of them
> ought to be called before suspending devices), while according to the
> ACPI specification, _GTS is to be executed right prior to entering
> the system sleep state and _BFS is to be executed right after the
> platfor firmware has returned control to the OS on wake up.
> 
> Move the execution of _GTS and _BFS to the right places.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Seems ok to me, but it is 2.6.25 material earliest, right?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
