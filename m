Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbYLUP50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbYLUP50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYLUP5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:57:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33281 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752239AbYLUP5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:57:16 -0500
Date: Sun, 21 Dec 2008 15:57:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: linux ext3 partition hosed, is this hardware of software error?
Message-ID: <20081221155720.36b700f7@lxorguk.ukuu.org.uk>
In-Reply-To: <20081221150302.GA3457@gamma.logic.tuwien.ac.at>
References: <20081221143640.GF1509@gamma.logic.tuwien.ac.at>
	<20081221144913.76ca53d3@lxorguk.ukuu.org.uk>
	<20081221150302.GA3457@gamma.logic.tuwien.ac.at>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Buffer I/O error on device sda3, logical block 12
> > > Buffer I/O error on device sda3, logical block 13
> > 
> > Right near the start of the disk.
> 
> Ah, that is the reason why grub is gone.

To be accurate - start of partition but the effect is the same yes.

> > Make a copy of the partition with a recovery tool and write it somewhere
> 
> ddrescue? partimage? Any other suggestion?

ddrescue should do the trick - anything which will copy all the valid
sectors and write out the lost ones as zero or similar preserving what is
left of the file.

> 
> > (file on another disk whatever) and keep it safe. Make a copy of that and
> > fsck the copy. You may need to use the alternate superblock option on
> > fsck for this.
> 
> Thanks, good hint, didn't know about that.

It's there for exactly this kind of situation.

Alan
