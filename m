Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbXE0QPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbXE0QPg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 12:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758750AbXE0QP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 12:15:27 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:48491 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620AbXE0QPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 12:15:25 -0400
Date: Sun, 27 May 2007 18:15:23 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Matt Mackall <mpm@selenic.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       yi.zhu@intel.com
Subject: Re: 2.6.22-rc2-mm1: NetworkManager fails to find ipw2200 again
Message-ID: <20070527181523.3cdbc153@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070525170209.40ad51d5.akpm@linux-foundation.org>
References: <20070525163621.GE11166@waste.org>
	<20070525164842.GA6220@suse.de>
	<3ae72650705251037p6b1632a5m45cdd999a294fcbd@mail.gmail.com>
	<20070525175319.GK11115@waste.org>
	<20070525210152.GL11115@waste.org>
	<20070525230109.GN11115@waste.org>
	<20070525231257.GA9616@suse.de>
	<20070525170209.40ad51d5.akpm@linux-foundation.org>
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

On Fri, 25 May 2007 17:02:09 -0700,
Andrew Morton <akpm@linux-foundation.org> wrote:

> > This wouldn't be the first time this patch has broken things :(
> 
> Why does checking these errors cause ipw2200 to fail?

I'd like to know this as well. Could someone stick in some printk's to
find out which symlink creation fails (which is most likely the
problem)?

> 
> > Andrew, can you drop this from your tree?
> 
> Would prefer that we debug things first.  It could be that ipw2200 is
> trying to create symlinks which already exist.  This might indicate a
> programming error in ipw2200, which is what the patch is *for*.  If it
> is indeed an ipw2200 bug then the lesson is that we should have been checking
> for errors on day one - that way, we'd never have shipped a buggy ipw2200 driver.
> 
> I have an ipw2200 - I'll see if I can reproduce this and I'll add some
> debugging code in there.  Probably that debugging code should become
> permanent.

Thanks, that would be much appreciated.

> 
> > Cornelia, can you rework this to not break things?
> 
> Things might be already broken?

Or I might have messed up (I hope not). Sorry for the pain anyway.
