Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbYHCTC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbYHCTC0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 15:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbYHCTCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 15:02:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58618 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751628AbYHCTCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 15:02:16 -0400
Date: Sun, 3 Aug 2008 19:45:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata)
 and IDE
Message-ID: <20080803194501.24fa3e51@lxorguk.ukuu.org.uk>
In-Reply-To: <1217783433.4179.18.camel@localhost.localdomain>
References: <1217779055.4179.10.camel@localhost.localdomain>
	<20080803173941.314edf33@lxorguk.ukuu.org.uk>
	<1217783433.4179.18.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > There is a trend in new hardware to interfaces that simply won't fit old
> > IDE so that process of libata only drivers is likely to continue.
> 
> Yes, that's SATA ... but legacy remains for a long time.

It isn't that simple. The newer PATA controllers are diverging from the
old style interfaces as well.

> Yes, I understand this ... if that means drivers/ata can't possibly be
> used by embedded until its dependence on SCSI is broken, then so be
> it ... but I think we should at least investigate what the issues and
> potential solutions are.

The simpler embedded wants a pure CF driver - no scsi, no libata, no
drivers/ide overhead, just about 4K of CF only pio driver.

> Well, I did notice from the lists that both drivers/ide and drivers/ata
> would be represented.  I've also observed that there's been a singular
> lack of discussion of this on the lists; plus it's the type of emotive
> issue that in-person discussions help to extract the heat from.

We've certainly discussed it in the past and I'm not sure its gotten that
personal - many people contribute to both trees for example, or are
directly cc'ing stuff between trees to ensure they stay in sync and any
useful info gets in both.

Anyway with my libata hat on I would say its far too early to worry about
this. Right now we have platforms that need old IDE and it is still
proving very useful to be able to ask people to try both. I don't quite
know why Bart is putting so much effort into polishing up the old IDE but
if he's enjoying it I don't really care 8)

Alan
