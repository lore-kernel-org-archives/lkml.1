Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbYLGUQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbYLGUQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 15:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbYLGUQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 15:16:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34520 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbYLGUQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 15:16:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: [Bug #11698] 2.6.27-rc7, freezes with &gt; 1 s2ram cycle
Date: Sun, 7 Dec 2008 21:16:07 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <49ZBswjGjrL.A.ECE.BGyNJB@chimera> <TpbYvO5GPt.A.nTF.2GyNJB@chimera> <1228373948.3927.39.camel@localhost>
In-Reply-To: <1228373948.3927.39.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072116.08218.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 4 of December 2008, Soeren Sonnenburg wrote:
> On Wed, 2008-12-03 at 23:40 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.26 and 2.6.27.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11698
> > Subject		: 2.6.27-rc7, freezes with &gt; 1 s2ram cycle
> > Submitter	: Soeren Sonnenburg <kernel@nn7.de>
> > Date		: 2008-09-29 11:29 (66 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122268780926859&w=4
> > Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
> 
> well it freezes at any s2ram resume attempt, even without X just from
> console.

There are quite some things you can try.

First, it would be helpful to verify if it also fails in the minimal
configuration, ie. when booted with init=/bin/bash, as described
in Documentation/power/basic-pm-debugging.txt under
"Testing minimal configuration".

Thanks,
Rafael
