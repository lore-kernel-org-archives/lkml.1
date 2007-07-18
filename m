Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbXGRIO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbXGRIO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 04:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbXGRIOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 04:14:43 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:31349 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbXGRIOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 04:14:41 -0400
Date: Wed, 18 Jul 2007 10:15:01 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] drivers/base/core: improve device_add() error
 handling, fix bugs
Message-ID: <20070718101501.6af017bc@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070718055348.GA5734@havoc.gtf.org>
References: <20070718055348.GA5734@havoc.gtf.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 01:53:48 -0400,
Jeff Garzik <jeff@garzik.org> wrote:

> 
> The following change was checked into 'warnings' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git
> 
> commit 5330916f5a11d8b7def46a6b3e14a831684032f5
> Author: Jeff Garzik <jeff@garzik.org>
> Date:   Wed Jul 18 01:41:29 2007 -0400
> 
>     drivers/base/core: improve device_add() error handling, fix bugs
>     
>     * silence several warnings by handling sysfs_create_link() failure
>     
>     * re-order some operations in error handling, to precisely reverse
>       the order of operations, i.e. unwind properly.
>     
>     Signed-off-by: Jeff Garzik <jeff@garzik.org>
> 
>  drivers/base/core.c |   46 ++++++++++++++++++++++++++++++----------------
>  1 file changed, 30 insertions(+), 16 deletions(-)

Hm, what about driver-core-check-return-code-of-sysfs_create_link.patch
(merged with ...-fix.patch) which has been in -mm for a while?
