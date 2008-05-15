Return-Path: <linux-kernel-owner+w=401wt.eu-S1761563AbYEOPiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761563AbYEOPiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 11:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbYEOPh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 11:37:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51319 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbYEOPh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 11:37:56 -0400
Date: Thu, 15 May 2008 17:45:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: John Stoffel <john@stoffel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
Message-ID: <20080515154533.GB30216@one.firstfloor.org>
References: <20080514174955.GA515@elte.hu> <6457.1210801515@vena.lwn.net> <87bq387cyn.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805141515020.3019@woody.linux-foundation.org> <482B65FE.4040402@firstfloor.org> <18476.20788.142218.370584@stoffel.org> <482C5281.7020306@firstfloor.org> <18476.21589.315367.664174@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18476.21589.315367.664174@stoffel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I must admit I used to have an ISA Cyclades 8 port serial card running
> in there, but now it's all PCI stuff.  It only had one ISA slot.  So
> yes, ISA SMP boxes are slowly dying, but they'll be around for a long
> time to come.

My point was that for those few users it's actually better to keep
the BKL. If you try to remove it on some old driver you cannot test
due to lack of hardware the risk of breaking the driver is higher than the 
gain you would get from removing it.  The best you can do in this
legacy code is to keep it running with minimal changes in the old
tested state (although for some of it it's doubtful it still does actually)

> 
> Andi> Also on 2 CPU systems BKL is not that critical anyways. It only
> Andi> starts to hurt on larger CPU counts.
> 
> True, but with the growing number of multicore systems, esp on
> desktops, it's going to be an issue.  

Multicore systems don't have ISA slots.

[yes I'm sure someone will tell me now about the ISA-over-USB device
that exists. Don't bother, it doesn't add anything to the point]

-Andi
