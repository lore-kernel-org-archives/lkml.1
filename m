Return-Path: <linux-kernel-owner+w=401wt.eu-S1756956AbYBXAJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbYBXAJX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 19:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbYBXAJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 19:09:11 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54065 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752000AbYBXAJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 19:09:09 -0500
Subject: Re: [GIT PATCH] scsi fixes for 2.6.25-rc2
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Olof Johansson <olof@lixom.net>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <47C0ACC1.1050306@garzik.org>
References: <1203779614.3139.4.camel@localhost.localdomain>
	 <20080223230126.GA23265@lixom.net>  <47C0ACC1.1050306@garzik.org>
Content-Type: text/plain
Date: Sat, 23 Feb 2008 18:09:04 -0600
Message-Id: <1203811744.3139.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-23 at 18:31 -0500, Jeff Garzik wrote:
> Olof Johansson wrote:
> > Hi,
> > 
> > On Sat, Feb 23, 2008 at 09:13:33AM -0600, James Bottomley wrote:
> > 
> >> Jeff Garzik (1):
> >>       mvsas: Add Marvell 6440 SAS/SATA driver
> > [...]
> >>  drivers/scsi/mvsas.c                | 2981 ++++++++++++++++++++++++++++++++++++
> > 
> > I just noticed that the file permissions on that file are 755 in current
> > git, that was probably not intentional?
> 
> Definitely not intentional.  They were 0644 in the original changeset 
> (the one from me you highlighted), then the second changeset updating 
> mvsas somehow changed the perms.

Actually, unfortunately, it was ... I just didn't spot it.  The second
patch has this in the header:

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
old mode 100644
new mode 100755

It's git slang for change the mode to executable ... no idea why marvell
would do that unless it's something windows related?  Anyway, I'll
change it back.

James


