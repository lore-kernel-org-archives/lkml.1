Return-Path: <linux-kernel-owner+w=401wt.eu-S1751695AbZCQOwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbZCQOwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 10:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbZCQOwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 10:52:30 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52668 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbZCQOw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 10:52:28 -0400
Subject: Re: [Bug #12612] hard lockup when interrupting cdda2wav
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       hias@horus.com
In-Reply-To: <20090317095254P.fujita.tomonori@lab.ntt.co.jp>
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera>
	 <qm8_cedJGaP.A.3-G.5OCvJB@chimera>
	 <20090317095254P.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 14:52:21 +0000
Message-Id: <1237301541.3253.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-17 at 09:53 +0900, FUJITA Tomonori wrote:
> On Sat, 14 Mar 2009 20:20:17 +0100 (CET)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
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
> > Date		: 2009-01-28 16:41 (46 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123316111415677&w=4
> > Handled-By	: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Patch		: http://marc.info/?l=linux-scsi&m=123371501613019&w=2
> 
> This still should be listed. I think that the fix (in James'
> scsi-misc) will be merged to 2.6.30-rc1 then be backported.

It hasn't shown any problems at all under test in -next ... hopefully
under a reasonable test pool.  I think we can move it across for current
bug fixes (crosses fingers).

James


