Return-Path: <linux-kernel-owner+w=401wt.eu-S1758440AbXJXNYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440AbXJXNYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 09:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbXJXNYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 09:24:25 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:41794 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753304AbXJXNYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 09:24:24 -0400
Subject: Re: [GIT PATCH] final SCSI pieces for the merge window
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <471E707B.1020505@garzik.org>
References: <1193173128.3434.1.camel@localhost.localdomain>
	 <471E6313.1040704@garzik.org>
	 <1193174424.3434.3.camel@localhost.localdomain>
	 <471E707B.1020505@garzik.org>
Content-Type: text/plain
Date: Wed, 24 Oct 2007 09:24:19 -0400
Message-Id: <1193232259.3396.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-23 at 18:06 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > On Tue, 2007-10-23 at 17:09 -0400, Jeff Garzik wrote:
> >> James Bottomley wrote:
> >>> This should be the final SCSI updates; it's mainly just a few accessor
> >>> completion updates and two driver merges (sym2 and qla2xxx) we also
> >>> secured DaveM's agreement to remove fcal/fc4, which explains the high
> >>> removal line count.
> >>>
> >>> The patch is available here:
> >>>
> >>> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> >> I guess I have the go-ahead to merge the end-CDROM-polling async 
> >> notification work you've been repeatedly ignoring?
> > 
> > I haven't been ignoring it ... it just needs quite a bit of work; the
> > best way to accelerate it seems to be simply to do it (add the
> > supported/trigger event bitmasks and expand the infrastructure).  I just
> > haven't had the time within the merge window.
> 
> James, things cannot get bottlenecked like this.  You have had MONTHS to 
> say something like this.  The code was ready BEFORE the merge window.

The patch in question is an interface to user space.  The problem with
those is that you can't put them in and refine them because the user
visible interface changes when you do that.

> I really think you have the knowledge to be SCSI maintainer, but not the 
> time.

The pot is calling the kettle black here, since libata was supposed to
have moved out of SCSI about three years ago by helping us move the
shared elements up to block.  As far as I can tell, the only progress
we've made in this area is me adding the odd API shift.

James


