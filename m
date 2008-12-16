Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbYLPQdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbYLPQdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:33:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbYLPQct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:32:49 -0500
Received: from smtp03.uc3m.es ([163.117.176.133]:44063 "EHLO smtp03.uc3m.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757864AbYLPQcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:32:48 -0500
From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Message-Id: <200812161632.mBGGWh213629@inv.it.uc3m.es>
Subject: Re: time_is_after_jiffies misnomer
In-Reply-To: <jeabawccup.fsf@sykes.suse.de> from "Andreas Schwab" at "Dec 
	16,2008 05:18:54 pm"
To: "Andreas Schwab" <schwab@suse.de>
Date: Tue, 16 Dec 2008 17:32:43 +0100 (MET)
CC: "linux kernel" <linux-kernel@vger.kernel.org>
X-Anonymously-To: 
Reply-To: ptb@inv.it.uc3m.es
X-message-flag: Had your Outlook virus, today?  
	http://www.counterpane.com/crypto-gram-0103.html#4
X-WebTV-Stationery: Standard\; BGColor=black\; TextColor=black
Reply-By: Sat, 1 Apr 2006 14:21:08 -0700
X-Mailer: ELM [version 2.4ME+ PL66 (25)]
X-imss-version: 2.051
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-18.2532 TC:1F TRN:22 TV:5.5.1026(16344.000)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Also sprach Andreas Schwab:"
[Charset iso-8859-1 unsupported, filtering to ASCII...]
> "Peter T. Breuer" <ptb@inv.it.uc3m.es> writes:
> 
> > Look at the two:
> >
> >    the current time is later than foo jiffies
> >                  |   |  |           `/.
> >                time_is_after_jiffies(foo)
> 
> It's not "foo jiffies", it's time "foo" vs time "jiffies" (where jiffies
> is the well known global variable).

Forgive me, but you don't seem to really be taking it on board here
either ...  what it SAYS to an english reader is the opposite of what
you intend it to MEAN, unfortunately :(.

So the name is wrong. It's simple to fix. Just change the name. The
simplest naming fix is from

    time_is_after_jiffies(foo)

to

    time_is_before_jiffies(foo)

but obviously that would create more confusion yet, given the
unfortunate current scheme!  So how about keeping the current macro
names but gradually phasing them out in favour of a parallel set of 
alternatives, which could be

    current_time_is_before_jiffies(foo)

?? That reads fine in english and this time it means what it says!

Best regards

Peter
