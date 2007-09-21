Return-Path: <linux-kernel-owner+w=401wt.eu-S1762286AbXIUUka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762286AbXIUUka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbXIUUkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:40:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44284 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbXIUUkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:40:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Date: Fri, 21 Sep 2007 22:53:00 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>, nigel@suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang\, Ying" <ying.huang@intel.com>,
       linux-pm@lists.linux-foundation.org,
       huang ying <huang.ying.caritas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.0709211540100.5816-100000@iolanthe.rowland.org> <200709212215.26978.rjw@sisk.pl> <87hcln69zv.fsf@jbms.ath.cx>
In-Reply-To: <87hcln69zv.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709212253.02158.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 21 September 2007 22:26, Jeremy Maitin-Shepard wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> [snip]
> 
> > The ACPI NVS area is explicitly marked as reserved and we don't save it.
> > On x86_64 we don't save any memory areas marked as reserved and yet the above
> > happens.
> 
> I think you have mentioned before, though, that ACPI is first
> initialized by the boot kernel, before it is later initialized by
> resuming kernel.  This could well be the source of the problem.

No, it's not.  I have tested that too with an ACPI-less boot kernel.

Greetings,
Rafael
