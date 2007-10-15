Return-Path: <linux-kernel-owner+w=401wt.eu-S1765092AbXJOQak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765092AbXJOQak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760098AbXJOQa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:30:29 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:55965 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760035AbXJOQa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:30:27 -0400
Date: Mon, 15 Oct 2007 17:30:07 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git patches] IDE updates (part 1)
In-Reply-To: <200710141738.39838.bzolnier@gmail.com>
Message-ID: <Pine.LNX.4.64N.0710151719580.16262@blysk.ds.pg.gda.pl>
References: <200710120034.49730.bzolnier@gmail.com>
 <Pine.LNX.4.64N.0710121518030.21684@blysk.ds.pg.gda.pl>
 <200710141738.39838.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Oct 2007, Bartlomiej Zolnierkiewicz wrote:

> > CONFIG_BLK_DEV_IDE_SWARM disabled by default -- that should probably be 
> > changed; I'll cook a patch).  I guess it is not possible to make everyone 
> > happy at once though, so please do not treat it as a hard objection. :-)
> 
> Hmm, it also seems that CONFIG_IDE_GENERIC=y may be removed now because
> IDE SWARM host driver does the probing itself?

 I do not think it should have relied on it in any way or otherwise 
"select" should have been used.  I recall confusion around this driver and 
even recently some breakage happened as a result of some fiddling with 
include/asm-mips/mach-generic/ide.h and the fact this platform is 
legacy-free -- there is nothing decoding subtractively on the PCI bus (no 
south bridge of any kind) and blind pokes at presumed ISA addresses result 
in bus error exceptions.

 I'll have a look at it in due course.

  Maciej
