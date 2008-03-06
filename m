Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbYCFWIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbYCFWIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 17:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765074AbYCFWHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 17:07:47 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54192 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765317AbYCFWHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 17:07:45 -0500
Subject: Re: [2.6 patch] SCSI_AIC94XX must depend on SCSI
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080306213938.GA1574@cs181133002.pp.htv.fi>
References: <200803062009.20309.toralf.foerster@gmx.de>
	 <20080306202246.GB5259@cs181133002.pp.htv.fi>
	 <1204835467.3062.42.camel@localhost.localdomain>
	 <20080306213938.GA1574@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 16:07:42 -0600
Message-Id: <1204841262.3062.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-06 at 23:39 +0200, Adrian Bunk wrote:
> This is the right fix for this bug.

Incidentally, just for future reference, this:

> We have:
> - SCSI=m
> - SCSI_AIC94XX=y
> - SCSI_MVSAS=m
> - SCSI_SAS_LIBSAS=y
> 
> The problem is:
> - SCSI_AIC94XX selects (and requires) SCSI_SAS_LIBSAS
> - SCSI_MVSAS selects (and requires) SCSI_SAS_LIBSAS
> - with SCSI=m a SCSI_SAS_LIBSAS=y is not linked into the kernel
> 
> SCSI_AIC94XX=y also results in the AIC94xx driver not being linked into 
> the kernel here (and that's also fixed by this patch), but this alone 
> wouldn't result in a build bug...

Is the right changelog for your fix (even if it got superceded), rather
than a compile dump that doesn't even mention the driver you're
patching.

James


