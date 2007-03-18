Return-Path: <linux-kernel-owner+w=401wt.eu-S932535AbXCRR6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbXCRR6q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 13:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932583AbXCRR6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 13:58:46 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34280 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932535AbXCRR6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 13:58:45 -0400
Date: Sun, 18 Mar 2007 18:58:46 +0100
From: Adrian Bunk <bunk@stusta.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Meyer <thomas@m3y3r.de>, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?utf-8?B?RnLDqWTDqXJpYw==?= RISS <frederic.riss@gmail.com>,
       Milan Broz <mbroz@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] clockevents: Fix suspend/resume to disk hangs
Message-ID: <20070318175846.GT752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <1174087552.13341.332.camel@localhost.localdomain> <45FBBDEA.9060708@m3y3r.de> <200703172247.03235.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200703172247.03235.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2007 at 10:47:01PM +0100, Rafael J. Wysocki wrote:
> On Saturday, 17 March 2007 11:07, Thomas Meyer wrote:
> >...
> > 2.) The first suspend to disk works with no problems, but the second
> > suspend to disk in a row results in an oops:
> >  ->resume_device ->
> > pci_device_resume->ata_host_resume->ahci_pci_device_resume->ata_pci_device_do_resume->pci_restore_state
> 
> Can you please see if this problem is already in the Adrian's list of known
> regressions?

AFAIK not, I've given it an own entry.

> Thanks,
> Rafael

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

