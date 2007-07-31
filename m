Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbXGaM7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbXGaM7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 08:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758121AbXGaM7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 08:59:15 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:51236 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976AbXGaM7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 08:59:14 -0400
Date: Tue, 31 Jul 2007 14:59:35 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       satyam@infradead.org, stern@rowland.harvard.edu
Subject: Re: [PATCH 4/7] sysfs: simplify sysfs_remove_dir()
Message-ID: <20070731145935.3398cfba@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <11858769083860-git-send-email-htejun@gmail.com>
References: <11858769082982-git-send-email-htejun@gmail.com>
	<11858769083860-git-send-email-htejun@gmail.com>
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

> With the shadow directories gone, sysfs_remove_dir() can be simplified.
> 
> * parent doesn't need to be grabbed separately.  Just access
>   old_dentry->d_parent.
> 
> * parent sd can never change.  Remove code to move under the new
>   parent.
> 
> * Massage comments a bit.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
>  fs/sysfs/dir.c |   26 ++++----------------------
>  1 files changed, 4 insertions(+), 22 deletions(-)
> 
It's not sysfs_remove_dir(), but sysfs_rename_dir() :) Otherwise this
looks good.

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
