Return-Path: <linux-kernel-owner+w=401wt.eu-S1762194AbXHVJY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762194AbXHVJY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbXHVJYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 05:24:48 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:28066 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbXHVJYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 05:24:47 -0400
Date: Wed, 22 Aug 2007 11:26:08 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: ebiederm@xmission.com, greg@kroah.com, linux-kernel@vger.kernel.org,
       satyam@infradead.org, stern@rowland.harvard.edu,
       containers@lists.osdl.org
Subject: Re: [PATCHSET] Sysfs cleanups from Eric W. Biederman
Message-ID: <20070822112608.1645030c@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <11876133893720-git-send-email-htejun@gmail.com>
References: <11876133893720-git-send-email-htejun@gmail.com>
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

On Mon, 20 Aug 2007 21:36:29 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Hello, all.
> 
> This is subset of Eric W. Biederman's "Sysfs cleanups & tagged
> directory support" patchset[1] with the following modifications.
> 
> * fix-i_mutex-locking-in-sysfs_get_dentry patch is added at the top
>   and #14-Don_t-use-lookup_one_len_kern and
>   #15-vfs-Remove-lookup_one_len_kern are dropped.  This is because #14
>   contained had a bug where it might created dentry/inode for an
>   already deleted sysfs_dirent.  I think it's benefitial to keep
>   single lookup path.
> 
> * Rewrote simplify-sysfs_get_dentry patch and
>   #08-Implement-__sysfs_get_dentry,
>   #09-Move-sysfs_get_dentry-below-__sysfs_get_dentry and
>   #10-Rewrite-sysfs_get_dentry-in-terms-of-__sysfs_get_dentry are
>   omitted as __sysfs_get_dentry() isn't used by anyone.
> 
> * #16, 19-25 are omitted as it isn't clear yet how the tagged entry
>   support will end up.
> 
> * readdir simplification fixed.
> 
> * sysfs_mutex double locking fixed.
> 
> The patchset is on top of the current -gregkh.

Survives some casual testing (including moving devices). Patches look
sane to me at a cursory glance as well (sorry, don't have much time at
the moment).
