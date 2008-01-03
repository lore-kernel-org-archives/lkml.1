Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbYACREl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbYACREl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbYACREa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:04:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48322 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbYACRE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:04:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 2/7] ACPI: Separate invocations of _GTS and _BFS from _PTS and _WAK
Date: Thu, 3 Jan 2008 18:06:45 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Moore, Robert" <robert.moore@intel.com>
References: <200712271903.53961.rjw@sisk.pl> <200712271915.17174.rjw@sisk.pl> <20080103104220.GA1732@elf.ucw.cz>
In-Reply-To: <20080103104220.GA1732@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031806.47451.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 3 of January 2008, Pavel Machek wrote:
> On Thu 2007-12-27 19:15:16, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The execution of ACPI global control methods _GTS and _BFS is
> > currently tied to the preparation to enter a sleep state and to the
> > leaving of the sleep state, respectively.  However, these functions
> > are called before disabling the nonboot CPUs and after enabling
> > them, respectively (in fact, on ACPI 1.0x systems the first of them
> > ought to be called before suspending devices), while according to the
> > ACPI specification, _GTS is to be executed right prior to entering
> > the system sleep state and _BFS is to be executed right after the
> > platfor firmware has returned control to the OS on wake up.
> > 
> > Move the execution of _GTS and _BFS to the right places.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Seems ok to me, but it is 2.6.25 material earliest, right?

Sure, it is.

[The patches are on top of 2.6.25 ones, btw. ;-)]

Thanks,
Rafael
