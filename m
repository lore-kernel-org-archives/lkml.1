Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbXJWVUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbXJWVUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbXJWVU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:20:27 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:33003 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752304AbXJWVU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:20:26 -0400
Subject: Re: [GIT PATCH] final SCSI pieces for the merge window
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <471E6313.1040704@garzik.org>
References: <1193173128.3434.1.camel@localhost.localdomain>
	 <471E6313.1040704@garzik.org>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 17:20:23 -0400
Message-Id: <1193174424.3434.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-23 at 17:09 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > This should be the final SCSI updates; it's mainly just a few accessor
> > completion updates and two driver merges (sym2 and qla2xxx) we also
> > secured DaveM's agreement to remove fcal/fc4, which explains the high
> > removal line count.
> > 
> > The patch is available here:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> 
> I guess I have the go-ahead to merge the end-CDROM-polling async 
> notification work you've been repeatedly ignoring?

I haven't been ignoring it ... it just needs quite a bit of work; the
best way to accelerate it seems to be simply to do it (add the
supported/trigger event bitmasks and expand the infrastructure).  I just
haven't had the time within the merge window.

James


