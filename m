Return-Path: <linux-kernel-owner+w=401wt.eu-S1759447AbXGaMT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447AbXGaMT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 08:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbXGaMTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 08:19:50 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:22732 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbXGaMTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 08:19:49 -0400
Date: Tue, 31 Jul 2007 14:19:53 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs/partitions/check.c: add_partition() warning fixes
 (take 4)
Message-ID: <20070731141953.656f0f4a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070731115016.GA6326@localhost.localdomain>
References: <20070730113847.GA28404@kernel.sg>
	<20070731115016.GA6326@localhost.localdomain>
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

On Tue, 31 Jul 2007 19:50:16 +0800,
WANG Cong <xiyou.wangcong@gmail.com> wrote:

> On Mon, Jul 30, 2007 at 07:38:47PM +0800, Eugene Teo wrote:
> >This patch fixes these warnings:
> >
> >fs/partitions/check.c: In function 'add_partition':
> >fs/partitions/check.c:391: warning: ignoring return value of 'kobject_add',
> >	declared with attribute warn_unused_result
> >fs/partitions/check.c:394: warning: ignoring return value of
> >	'sysfs_create_link', declared with attribute warn_unused_result
> >fs/partitions/check.c:401: warning: ignoring return value of
> >	'sysfs_create_file', declared with attribute warn_unused_result
> >
> >Got it right this time. Thanks Cornelia for help.
> >
> 
> <snip>
> 
> This was already done some months ago, see this:
> http://marc.info/?l=linux-mm-commits&m=117624330000536&w=2
> 
> I don't know why this work is duplicated.

Ha, that may explain my feeling of deja vu...

IIRC, Andrew dropped the patch from -mm due to clashes with other
patches. Did you try to re-submit it?
