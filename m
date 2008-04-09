Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbYDIKnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbYDIKnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 06:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbYDIKnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 06:43:37 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:41060 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbYDIKng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 06:43:36 -0400
Date: Wed, 9 Apr 2008 07:42:53 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10117] 2.6.25-current-git hangs on boot (pci=nommconf
	helps)
Message-ID: <20080409104253.GA3786@localhost.ift.unesp.br>
References: <SvnMeM-aZi.A.oxF.hBA_HB@albercik> <1207731482.9487.46.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207731482.9487.46.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed  9.Apr'08 at 10:58:02 +0200, Soeren Sonnenburg wrote:
> On Wed, 2008-04-09 at 01:02 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.24.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10117
> > Subject		: 2.6.25-current-git hangs on boot (pci=nommconf helps)
> > Submitter	: Soeren Sonnenburg <kernel@nn7.de>
> > Date		: 2008-02-23 18:55 (46 days old)
> > References	: http://lkml.org/lkml/2008/2/23/263
> > 		  http://lkml.org/lkml/2008/4/4/41
> 
> I could not anymore trigger this, though suddenly Carlos...

Yes, I can reproduce it with 10% chance. I will also reply in another
thread to Venkatesh, but here it goes:

1) Does not hang with CONFIG_CPUIDLE=n (17 boots OK)

2) It hangs with processor.max_cstate=2 (hung at the 10th boot)

3) Does not hang with processor.max_cstate=1 (20 boots OK)
