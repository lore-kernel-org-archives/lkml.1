Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745Ab0AGOp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab0AGOp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 09:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131Ab0AGOp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 09:45:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab0AGOp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 09:45:26 -0500
Subject: Re: latest git pull changed drivers/scsi/lpfc/lpfc_hw4.h to
 executable
From: James Bottomley <James.Bottomley@suse.de>
To: Thomas Backlund <tmb@mandriva.org>
Cc: linux-kernel@vger.kernel.org, james.smart@emulex.com,
       torvalds@linux-foundation.org
In-Reply-To: <4B45B496.90907@mandriva.org>
References: <4B45B496.90907@mandriva.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jan 2010 09:45:21 -0500
Message-Id: <1262875521.3025.5.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 12:16 +0200, Thomas Backlund wrote:
> At latest pull, lpfs_hw4.h got set to executable...
> 
> git show def9c7a994f194377a23e687e6fd39b46c3ce631 --summary
> 
> states:
> 
> commit def9c7a994f194377a23e687e6fd39b46c3ce631
> Author: James Smart <james.smart@emulex.com>
> Date:   Mon Dec 21 17:02:28 2009 -0500
> 
>      [SCSI] lpfc 8.3.7: Fix hardware/SLI relates issues
> 
>      Fix hardware/SLI relates issues:
>      - Fix CNA uses more than one EQ when in INTx interrupt mode.
>      - Fix driver tries to process failed read FCF record mailbox request.
>      - Fix allocating single receive buffer breaks FCoE receive queue.
>      - Support new read FCF record mailbox error case.
> 
>      Signed-off-by: James Smart <james.smart@emulex.com>
>      Signed-off-by: James Bottomley <James.Bottomley@suse.de>
> 
>   mode change 100644 => 100755 drivers/scsi/lpfc/lpfc_hw4.h
> 
> 
> While looking at the same tree, I also noticed that:
> drivers/scsi/lpfc/lpfc_hbadisc.c is also executable.
> 
> I guess they should be fixed.

I'll remove the x flag for both.  I suppose a commit check that warns on
executables might be in order, since adding them to the tree is a rare
exception rather than a usual occurrence.

James


