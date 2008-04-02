Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbYDBSGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbYDBSGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbYDBSGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:06:07 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:22941 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755263AbYDBSGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:06:06 -0400
Message-ID: <47F3CAFC.2050401@panasas.com>
Date: Wed, 02 Apr 2008 21:05:48 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.25-rc8
References: <1207082197.3100.26.camel@localhost.localdomain>
In-Reply-To: <1207082197.3100.26.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2008 18:05:52.0710 (UTC) FILETIME=[30825660:01C894EC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01 2008 at 23:36 +0300, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> This patch constitutes three bug fixes (the reversion of the BSG queue
> fix is the most serious; without it we're getting eventual corruption in
> systems).  The other two fix error legs or misleading reporting.  The
> remaining 8 patches are all updates to the mvsas driver which was a late
> addition at the -rc1 phase, so while they're not truly bug fixes, they
> are enhancements to make that unreleased driver more roubust for 2.6.25.
> 
> The patch is here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> 
> The short changelog is:
> 
> James Bottomley (2):
>       libsas: Warn if ATA device detected but CONFIG_SCSI_SAS_ATA not set
>       Revert " fix bsg queue oops with iscsi logout"
> 
<snip>

Does this mean that we still have the iscsi logout bug if used from bsg
in 2.6.25 kernel? I just want to know what are the out-of-tree patches 
I will need. Will the proper fix be candidate for the stable releases
of 2.6.25?

Thanks
Boaz
