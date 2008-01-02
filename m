Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbYABDbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbYABDbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 22:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYABDa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 22:30:56 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35299 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753875AbYABDaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 22:30:55 -0500
Subject: Re: 2.6.24-rc6-git7: Reported regressions from 2.6.23
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Boaz Harrosh <bharrosh@panasas.com>,
       Alan Cox <alan@redhat.com>
In-Reply-To: <alpine.LFD.1.00.0801011408470.32517@woody.linux-foundation.org>
References: <200801012202.57851.rjw@sisk.pl>
	 <alpine.LFD.1.00.0801011408470.32517@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 01 Jan 2008 21:30:50 -0600
Message-Id: <1199244650.3252.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-01 at 14:26 -0800, Linus Torvalds wrote:
> > Subject	: Problems on booting
> > Submitter	: "werner" <werner@copaya.yi.org>
> > Date		: 2007-12-22 14:29
> > References	: http://lkml.org/lkml/2007/12/22/110
> > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9621
> > Handled-By	: 
> > Patch		: 
> 
> Hmm. I assume the "-git6" and "-git7" are 2.6.24-rc4-gitX, ie commits
> 
>  - 2.6.24-rc5-git6: 3e3b3916a9c5c28a16528585478de19fea59816b
>  - 2.6.24-rc5-git7: fbdcf18df73758b2e187ab94678b30cd5f6ff9f9
> 
> and doing a
> 
> 	gitk 3e3b3916a9..fbdcf18df7
> 
> does show a SCSI merge, and two commits that touch drivers/scsi/initio.*.
> 
> James, Alan and Boaz, ideas? 

Initio has been suspected broken even after all the bug fixes (I
actually said that in the last pull request).  We just couldn't get a
tester to confirm the suspicion.  The commits were for known issues but
it proved impossible to get any of the reporters to verify.

Could you direct this poster to linux-scsi and we'll see if we can
finger the root cause (which will be difficult to do without getting a
boot trace).

James


