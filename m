Return-Path: <linux-kernel-owner+w=401wt.eu-S1762650AbXHQH5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762650AbXHQH5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 03:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756948AbXHQH4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 03:56:55 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:48563 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbXHQH4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 03:56:54 -0400
Date: Fri, 17 Aug 2007 09:57:42 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: don't warn on removal of a nonexistent binary
 file
Message-ID: <20070817095742.146b4080@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <46C4F79C.6020905@gmail.com>
References: <Pine.LNX.4.44L0.0708161609060.2553-100000@iolanthe.rowland.org>
	<46C4F79C.6020905@gmail.com>
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

On Fri, 17 Aug 2007 10:19:24 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Alan Stern wrote:
> > This patch (as960) removes the error message and stack dump logged by
> > sysfs_remove_bin_file() when someone tries to remove a nonexistent
> > file.  The warning doesn't seem to be needed, since none of the other
> > file-, symlink-, or directory-removal routines in sysfs complain in a
> > comparable way.
> > 
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> Acked-by: Tejun Heo <htejun@gmail.com>

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
