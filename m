Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbYLSUxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbYLSUxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYLSUxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:53:42 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46832 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751201AbYLSUxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:53:41 -0500
Subject: Re: Firmware patches for SCSI
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jaswinder Singh <jaswinderlinux@gmail.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <3f9a31f40812191241q40dafdb0lfd2f4487f2870e2@mail.gmail.com>
References: <3f9a31f40812191153n636888f4i549409453266d58c@mail.gmail.com>
	 <1229718543.18778.4.camel@localhost.localdomain>
	 <3f9a31f40812191241q40dafdb0lfd2f4487f2870e2@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 19 Dec 2008 15:53:51 -0500
Message-Id: <1229720031.18778.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-12-20 at 02:11 +0530, Jaswinder Singh wrote:
> Hello James,
> 
> On Sat, Dec 20, 2008 at 1:59 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >
> > Um ... depends how they got into linux-next.  The head commit just says
> >
> 
> They got into linux-next via David Woodhouse. :
> http://git.infradead.org/users/dwmw2/firmware-2.6.git
> 
> > Merge commit 'firmware/master'
> >
> > Which isn't very descriptive of where it came from.  It looks like
> > either a tree that linux-next shouldn't pull (or one the owner forgot to
> > push to linus).
> >
> 
> Earlier due to Firmware issues firmware patches are going directly
> though David Woodhouse.
> 
> Now firmware issues are solved so David wants that the _driver_
> patches should be sent directly to the appropriate maintainers / mailing lists.

OK, then whatever tree contains them needs to eject them or be dropped
from linux-next.

> So I am curious that should I resend these patches based on which git tree.

Yes please.  For me it would be against scsi-misc ... for the other
drivers it would be their development tree.  The simplest thing to do is
probably to rebase them all on top of linux-next (which contains all of
our trees) and then send them to the individual subsystem maintainer
lists.

James


