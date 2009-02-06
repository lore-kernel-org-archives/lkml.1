Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbZBFHeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbZBFHeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZBFHe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:34:27 -0500
Received: from sh.osrg.net ([192.16.179.4]:45792 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbZBFHe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:34:26 -0500
Date: Fri, 6 Feb 2009 16:33:44 +0900
To: hias@horus.com
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com
Subject: Re: [Bug #12612] hard lockup when interrupting cdda2wav
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090205131644.GA5731@horus.com>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera>
	<CGyEB0S4BpO.A.fLB.T5YiJB@chimera>
	<20090205131644.GA5731@horus.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090206163257W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 06 Feb 2009 16:33:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009 14:16:44 +0100
Matthias Reichl <hias@horus.com> wrote:

> On Wed, Feb 04, 2009 at 11:58:51AM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.27 and 2.6.28.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12612
> > Subject		: hard lockup when interrupting cdda2wav
> > Submitter	: Matthias Reichl <hias@horus.com>
> > Date		: 2009-01-28 16:41 (8 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123316111415677&w=4
> > Handled-By	: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> This bug is still present in 2.6.28.3.

There is a fix against scsi-misc:

http://marc.info/?l=linux-scsi&m=123371501613019&w=2

I might need to fix it in a different way though.

There are other pending patches to fix other sg oops in scsi-misc so
the above fix can't be cleanly applied to 2.6.28.X. I'll send a patch
for 2.6.28.X once I get SCSI maintainer's ACK on it.

Sorry for the inconvenience,
