Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbXIXLmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbXIXLmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 07:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbXIXLm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 07:42:28 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:49785 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbXIXLm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 07:42:28 -0400
Date: Mon, 24 Sep 2007 12:42:20 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Peter Fordham <peter.fordham@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: fpu IO port reservation (arch/i386)
In-Reply-To: <20070921193035.GA16811@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64N.0709241235490.22491@blysk.ds.pg.gda.pl>
References: <a71b7b480709210622l23481221pd09302a827b55eb@mail.gmail.com>
 <Pine.LNX.4.64N.0709211440380.2724@blysk.ds.pg.gda.pl> <p73y7f07zuz.fsf@bingen.suse.de>
 <Pine.LNX.4.64N.0709211724470.2724@blysk.ds.pg.gda.pl>
 <20070921193035.GA16811@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Andi Kleen wrote:

> >  For the curious the details of all the hassle are reasonably well 
> > described in the Intel's AP-578 application note.
> 
> Thanks. Ok it has to stay for for i386 then; although it would be in theory
> possible to only reserve when the CPU is a real 386. For x86-64 it's
> gone now.

 For anything newer the latch is still there in the chipset; most likely 
in the south bridge and probably actively decoded (irrespective of the 
architecture of the bit behind the north bridge) though it may be possible 
to disable it in a chip-specific manner.  If there is no south bridge in a 
given system, then it is probably safe not to claim the port.

  Maciej
