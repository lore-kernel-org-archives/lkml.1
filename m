Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbXDRAq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbXDRAq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 20:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbXDRAq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 20:46:58 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:43532 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbXDRAq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 20:46:57 -0400
X-Originating-Ip: 24.6.145.253
Date: Tue, 17 Apr 2007 20:46:12 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Bill Davidsen <davidsen@tmr.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH][RFC] Kill off legacy power management stuff.
In-Reply-To: <46254666.2020308@tmr.com>
Message-ID: <Pine.LNX.4.64.0704172045100.18821@localhost.localdomain>
References: <Pine.LNX.4.64.0704122025380.3628@CPE00045a9c397f-CM001225dbafb6>
 <200704131022.45315.rjw@sisk.pl> <46254666.2020308@tmr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-14.854, required 5, ALL_TRUSTED -1.80, BAYES_00 -15.00,
	INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_NJABL_DUL 1.95,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, Bill Davidsen wrote:

> Rafael J. Wysocki wrote:
> > [appropriate CCs added]
> >
> > On Friday, 13 April 2007 02:33, Robert P. J. Day wrote:
> > > just something i threw together, not in final form, but it represents
> > > tossing the legacy PM stuff.  at the moment, the menuconfig entry for
> > > PM_LEGACY lists it as "DEPRECATED", while the help screen calls it
> > > "obsolete."  that's a good sign that it's getting close to the time
> > > for it to go, and the removal is fairly straightforward, but there's
> > > no mention of its removal in the feature removal schedule file.
> >
> > It's been like this for a long long time.  I think you're right that it can
> > be
> > dropped, but I don't know the details (eg. why it hasn't been dropped yet).
> >
> One reason was that there are (were?) a number of machines which only powered
> down properly using apm. It was discussed as part of shutting down after power
> failure when your UPS is running out of power.

um ... what does APM have to do with legacy PM?  two different issues,
no?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
