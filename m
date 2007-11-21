Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbXKUPiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbXKUPiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 10:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750696AbXKUPh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 10:37:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:56668 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbXKUPh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 10:37:56 -0500
Date: Wed, 21 Nov 2007 16:37:55 +0100
From: Jan Kara <jack@suse.cz>
To: Dave Bailey <dsbailey@pacbell.net>
Cc: linux-kernel@vger.kernel.org, Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: Problem with ufs nextstep in 2.6.18 (debian)
Message-ID: <20071121153755.GB3963@atrey.karlin.mff.cuni.cz>
References: <4743438F.3000904@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4743438F.3000904@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This problem has been around since kernel 2.6.16, and I see it in
> 2.6.23.1-10.fc7. It occurs in the ufs_check_page function of ufs/dir.c
> at the Espan test, which seems unnecessary for NextStep/OpenStep
> files systems. The following patch preserves the test for other file
> systems and makes the mount useful for NextStep/OpenStep:
> (against the 2.6.23.1-10.fc7 source tree)
> 
> dsb@Zeno-Dyn[1012]$ diff dir.c dir.c.orig
> 108,110d107
> <       unsigned mnext = UFS_SB(sb)->s_mount_opt &
> <         (UFS_MOUNT_UFSTYPE_NEXTSTEP || UFS_MOUNT_UFSTYPE_NEXTSTEP_CD ||
> <          UFS_MOUNT_UFSTYPE_OPENSTEP);
> 131c128
> <               if ((mnext == 0) & (((offs + rec_len - 1) ^ offs) & 
> ~chunk_mask))
> ---
> >               if (((offs + rec_len - 1) ^ offs) & ~chunk_mask)
  Thanks for your contribution but we cannot take it as is - at least
Signed-off-by line is missing and the patch should also be in unified
diff format. Please read linux/Documentation/SubmittingPatches...
Thanks.

							Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
