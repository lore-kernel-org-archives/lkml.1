Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbYDBSQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbYDBSQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756580AbYDBSQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:16:19 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41866 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756483AbYDBSQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:16:18 -0400
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.25-rc8
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <47F3CAFC.2050401@panasas.com>
References: <1207082197.3100.26.camel@localhost.localdomain>
	 <47F3CAFC.2050401@panasas.com>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 13:16:14 -0500
Message-Id: <1207160174.3082.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 21:05 +0300, Boaz Harrosh wrote:
> On Tue, Apr 01 2008 at 23:36 +0300, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > This patch constitutes three bug fixes (the reversion of the BSG queue
> > fix is the most serious; without it we're getting eventual corruption in
> > systems).  The other two fix error legs or misleading reporting.  The
> > remaining 8 patches are all updates to the mvsas driver which was a late
> > addition at the -rc1 phase, so while they're not truly bug fixes, they
> > are enhancements to make that unreleased driver more roubust for 2.6.25.
> > 
> > The patch is here:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> > 
> > The short changelog is:
> > 
> > James Bottomley (2):
> >       libsas: Warn if ATA device detected but CONFIG_SCSI_SAS_ATA not set
> >       Revert " fix bsg queue oops with iscsi logout"
> > 
> <snip>
> 
> Does this mean that we still have the iscsi logout bug if used from bsg
> in 2.6.25 kernel? I just want to know what are the out-of-tree patches 
> I will need. Will the proper fix be candidate for the stable releases
> of 2.6.25?

I don't know yet.  The discussion is here:

http://marc.info/?t=120620205200001

James


