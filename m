Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbYDBPqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbYDBPqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 11:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYDBPqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 11:46:38 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:38154 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753739AbYDBPqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 11:46:37 -0400
Date: Wed, 2 Apr 2008 11:46:36 -0400
To: Frans Pop <elendil@planet.nl>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Message-ID: <20080402154636.GH24237@csclub.uwaterloo.ca>
References: <200804021524.27222.elendil@planet.nl> <20080402135729.GB24239@csclub.uwaterloo.ca> <200804021629.41153.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804021629.41153.elendil@planet.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 04:29:40PM +0200, Frans Pop wrote:
> Not sure. As the system only has 32MB RAM I'd say sometime late 1990s.

Well if Win95 was preinstalled, and being a 233MMX, then probably around
1997 or 1998, although just before Win98 came out I imagine.

> Could be. What would it be then? ISA? Any way to recognize that?

Yeah ISA seems likely.

Given IDE says PIO mode only, it sure isn't a busmastering IDE
controller.

> I did find a product page, but it's low on real specs:
> http://www.toshiba.ca/web/product.grp?lg=en&section=1&group=223&product=1605
> 
> Well, in the Debian Installer we prefer to load things automatically 
> whenever possible. If the kernel does not do it, that's fine.

I am sure the debian installer used to always load ide-generic after
trying everything else.  There was probably a reason for that.  You
never have been able to detect isa devices releably (even after pnp was
invented).  Certainly the debian installer in 2.0 worked fine when I
installed my 486.  Having reinstalled (only upgraded) ever since, I
can't say if the installer would still work on it (I just figured it
probably would).  I could try it out again though.

> But to have the installer itself automatically load ide-generic for the 
> user, we'd still have to somehow recognize that we need the driver.
> Any ideas/suggestions what to look for?

If you can't see any other disks, load it.  Heck load it last no matter
what since any supported IDE ports should have already had their driver
loaded, so worst case it does nothing in which case the autoclean of
unneeded kernel modules could remove it again, and best case it finds an
old isa/vlb style IDE controller on the standard port numbers and works
with it.

-- 
Len Sorensen
