Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbXE3Lyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbXE3Lyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 07:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXE3Lye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 07:54:34 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:20913 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbXE3Lyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 07:54:33 -0400
Date: Wed, 30 May 2007 13:54:32 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, dmitry.torokhov@gmail.com, oneukum@suse.de,
       rpurdie@rpsys.net, stern@rowland.harvard.edu, maneesh@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] sysfs: implement sysfs flags and SYSFS_FLAG_REMOVED
Message-ID: <20070530135432.19422e01@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <11803701863982-git-send-email-htejun@gmail.com>
References: <11803701861778-git-send-email-htejun@gmail.com>
	<11803701863982-git-send-email-htejun@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 01:36:26 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Rename sysfs_dirent->s_type to s_flags, pack type into lower eight
> bits and use the rest for flags.  sysfs_type() can used to access the
> type.  This patch also implements SYSFS_FLAG_REMOVED which is used to
> improve sanity check in sysfs_deactivate().  The flag will also be
> used to make directory entries reclamiable.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
>  fs/sysfs/dir.c        |   37 +++++++++++++++++++++++--------------
>  fs/sysfs/inode.c      |    5 +++--
>  fs/sysfs/mount.c      |    2 +-
>  fs/sysfs/sysfs.h      |    7 ++++++-
>  include/linux/sysfs.h |    4 ++++
>  5 files changed, 37 insertions(+), 18 deletions(-)

This seems sane, but I'd split this into two patches: One introducing
sysfs_type(), and one adding SYSFS_FLAG_REMOVED.
