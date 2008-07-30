Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbYG3UFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbYG3UFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYG3UFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:05:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940AbYG3UFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:05:08 -0400
Date: Wed, 30 Jul 2008 13:04:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: bwalle@suse.de, greg@kroah.com, hugh@veritas.com, gregkh@suse.de,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, haveblue@us.ibm.com
Subject: Re: linux-next: Tree for July 29
Message-Id: <20080730130419.49986a25.akpm@linux-foundation.org>
In-Reply-To: <200807302127.42148.bzolnier@gmail.com>
References: <20080729172337.b3d74100.sfr@canb.auug.org.au>
	<20080730090650.79a5a749@kopernikus.site>
	<20080730021947.def99edc.akpm@linux-foundation.org>
	<200807302127.42148.bzolnier@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 21:27:41 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Wednesday 30 July 2008, Andrew Morton wrote:
> > On Wed, 30 Jul 2008 09:06:50 +0200 Bernhard Walle <bwalle@suse.de> wrote:
> > 
> > > * Greg KH <greg@kroah.com> [2008-07-29 21:48]:
> > > > > Isn't this the opposite end of the same problem for which Bernhard
> > > > > has been repeatedly trying to find a taker for his patch:
> > > > > 
> > > > > http://article.gmane.org/gmane.linux.kernel.kexec/1882
> > > > 
> > > > Yes.  It's not the kobject patch at fault here, it's the use of kobjects
> > > > so early in the boot process.  That needs to be fixed.
> > 
> > It was a bit optimistic to stick an unconditional GFP_KERNEL allocation
> > into the previously-atomic kobject_init().
> > 
> > It's only 128 bytes, so why can't we fix both problems thusly?
> 
> Fixes the bug for me (also true for previous patch from Bernhard).
> 

Cool.

The offending patch has just got itself turfed from linux-next so my
fix now has nothing to fix.

We'll see what happens!
