Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbXKNBLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbXKNBLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761011AbXKNBLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:11:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59545 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764137AbXKNBLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:11:19 -0500
Date: Tue, 13 Nov 2007 17:11:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-11-13-04-14.tar.gz uploaded
Message-Id: <20071113171113.06f2b26f.akpm@linux-foundation.org>
In-Reply-To: <200711132020.33124.kjwinchester@gmail.com>
References: <200711131215.lADCFfht009739@imap1.linux-foundation.org>
	<200711132020.33124.kjwinchester@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 20:20:32 -0400 Kevin Winchester <kjwinchester@gmail.com> wrote:

> On November 13, 2007 08:15:41 am akpm@linux-foundation.org wrote:
> > The mm snapshot broken-out-2007-11-13-04-14.tar.gz has been uploaded to
> >
> >   
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-11-13-
> >04-14.tar.gz
> >
> > It contains the following patches against 2.6.24-rc2:
> >
> 
> <snip>
> 
> How exactly do I go about trying out this snapshot?  I did the following:
> 
> - exported 2.6.24-rc2 from my cloned git tree to a separate folder
> - installed quilt
> - extracted the patches to the "patches" directory at the top level of the 
> 2.6.24-rc2 tree
> - copied the list of patches from your mail into a "series" file which I 
> placed in the "patches" directory

The tarball contains a copy of the series file.  For some reason LARGE
numbers of people miss it and ask me "hey, where's the series file?".  Odd.

> - ran "quilt push -a"
> 
> The result was that all of the patches seem to have been applied, but there 
> were many offsets and at least one fuzzed patch.  Should they have applied 
> cleanly?  Is quilt the way I am supposed to be applying these patches?

Yes, the -mm patches contain large amount of fuzz.  I'll occasionally go in
and do a mass defuzzing (shaving?) but it all goes fuzzy again within a
day.

I _could_ rediff all the time, but I keep all the patches under revision
control and I often need to grab the previous version of a patch (when I've
just dropped an earlier patch, and that earlier patch had caused me to redo
this patch).  Having lots of revisions due to unnecessary rediffing would
complicate that.

>  Is 
> there a reason that there is no "series" file in the archive with the 
> patches?

It's in there ;)

btw, I put the patches in a directory called "broken-out" so that you can
untar them in your kernel tree and not have them stomped all over your
existing patches/ directory.  symlink it...

