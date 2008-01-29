Return-Path: <linux-kernel-owner+w=401wt.eu-S933425AbYA2Suw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbYA2Suw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYA2Sum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:50:42 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59739 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752174AbYA2Suk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:50:40 -0500
Date: Tue, 29 Jan 2008 18:46:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: Richard Heck <rgheck@bobjweil.com>, Gene Heskett <gene.heskett@gmail.com>,
       Zan Lynx <zlynx@acm.org>, Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
Message-ID: <20080129184613.16846ae5@core>
In-Reply-To: <alpine.LNX.1.00.0801291202550.13593@iabervon.org>
References: <200801272122.21823.gene.heskett@gmail.com>
	<1201539043.31293.7.camel@zem>
	<1201540830.6526.19.camel@localhost>
	<200801281230.32910.gene.heskett@gmail.com>
	<alpine.LNX.1.00.0801281248190.13593@iabervon.org>
	<479E1D9E.3000900@bobjweil.com>
	<20080129121201.2f727f5f@core>
	<alpine.LNX.1.00.0801291202550.13593@iabervon.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The SCSI error reporting really ought to include a simple interpretation 
> of the error for end users ("The drive doesn't support this command" "A 
> sector's data got lost" "The drive timed out" "The drive failed" "The 
> drive is entirely gone"). There's too much similarity between the message 
> you get when you try a SMART test that doesn't apply to the drive and what 
> you get when the drive is broken.

That would be the SCSI verbose messages option. I think the Eric
Youngdale consortium added it about Linux 1.2. Nowdays its always built
that way.

> And it's possible that the error recovery is suboptimal in some cases. It 
> seems to like resetting drives too much; perhaps if it keeps seeing the 
> same problem and resetting the drive, it should decide that the drive's 
> error reporting is just bad and just ignore that error like the old IDE 
> did (but, in this case, after saying what it's doing).

Nothing like casually praying the users data hasn't gone for a walk is
there. If we don't act on them the users don't report them until
something really bad occurs so that isn't an option.

Alan
