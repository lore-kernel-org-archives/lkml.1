Return-Path: <linux-kernel-owner+w=401wt.eu-S1751858AbXLIOBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbXLIOBN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 09:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbXLIOA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 09:00:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42874 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbXLIOAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 09:00:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Date: Sun, 9 Dec 2007 15:20:03 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org
References: <200712080340.49546.rjw@sisk.pl> <20071208013631.3147986a.akpm@linux-foundation.org> <475B90C7.4070505@gmail.com>
In-Reply-To: <475B90C7.4070505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712091520.04740.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 9 of December 2007, Tejun Heo wrote:
> Hello,
> 
> Andrew Morton wrote:
> >> Subject		: PATA scan: ACPI Exception AE_AML_PACKAGE_LIMIT... is beyond end of object
> >> Submitter	: Hans de Bruin <bruinjm@xs4all.nl>
> >> References	: http://bugzilla.kernel.org/show_bug.cgi?id=9320
> >> Handled-By	: Robert Moore <Robert.Moore@intel.com>
> >> 		  Tejun Heo <htejun@gmail.com>
> >> 		  Fu Michael <michael.fu@intel.com>
> >> Patch		: 
> >>
> > 
> > A number of other people are seeing the same thing and Tejun is
> > putting in a blacklist of machines which cannot use libata+acpi.
> > That patch is not yet in any git tree which I pull.
> > 
> > AFACIT the machines kepe working OK - there's just some nasty dmesg
> > spew.
> > 
> > If any machines _are_ breaking then this could cause real problems
> > and I'd prefer that we either go for a whitelist or arrange to
> > detect the condition and fall back to non-acpi ata.
> 
> The pending patchset should make ATA ACPI quite resistant to failures.

Are you going to push it for 2.6.24?

> Known bad boards can be blacklisted (currently only one is on the
> list), ATA ACPI is disabled quicker if ACPI evalution fails, execution
> errors are handled better and commands which are intended to help the
> vendor instead of the user are filtered.  So, I think we have enough
> safety nets.

Sounds good.  :-)

Thanks,
Rafael
