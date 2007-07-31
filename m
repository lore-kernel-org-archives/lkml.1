Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbXGaM4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbXGaM4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 08:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760750AbXGaM41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 08:56:27 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:2411 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760729AbXGaM4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 08:56:25 -0400
Date: Tue, 31 Jul 2007 14:56:28 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       satyam@infradead.org, stern@rowland.harvard.edu
Subject: Re: [PATCH 1/7] sysfs: fix locking in sysfs_lookup() and
 sysfs_rename_dir()
Message-ID: <20070731145628.6989f255@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1185876908509-git-send-email-htejun@gmail.com>
References: <11858769082982-git-send-email-htejun@gmail.com>
	<1185876908509-git-send-email-htejun@gmail.com>
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

On Tue, 31 Jul 2007 19:15:08 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> sd children list walking in sysfs_lookup() and sd renaming in
> sysfs_rename_dir() were left out during i_mutex -> sysfs_mutex
> conversion.  Fix them.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
>  fs/sysfs/dir.c |   21 ++++++++++++---------
>  1 files changed, 12 insertions(+), 9 deletions(-)

Looks sane.

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
