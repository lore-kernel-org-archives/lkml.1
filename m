Return-Path: <linux-kernel-owner+w=401wt.eu-S1763039AbXGaNdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763039AbXGaNdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761899AbXGaNdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:33:14 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:7560 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761125AbXGaNdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:33:12 -0400
Date: Tue, 31 Jul 2007 15:33:32 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       satyam@infradead.org, stern@rowland.harvard.edu
Subject: Re: [PATCH 7/7] sysfs: make sysfs_addrm_finish() return void
Message-ID: <20070731153332.36debdd6@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <11858769093479-git-send-email-htejun@gmail.com>
References: <11858769082982-git-send-email-htejun@gmail.com>
	<11858769093479-git-send-email-htejun@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 19:15:09 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> With the previous sysfs_add_one() update, there is only one user of
> the return value of sysfs_addrm_finish() and the user can switch to
> testing @sd easily.  Make sysfs_addrm_finish() return void for cleaner
> semantics as suggested by Satyam Sharma.
> 
> This patch doesn't introduce any noticeable behavior change.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Satyam Sharma <satyam.sharma@gmail.com>
> ---
>  fs/sysfs/dir.c   |    7 +------
>  fs/sysfs/inode.c |    7 +++++--
>  fs/sysfs/sysfs.h |    2 +-
>  3 files changed, 7 insertions(+), 9 deletions(-)
> 
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
