Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbYFBOKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbYFBOKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 10:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbYFBOKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 10:10:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33776 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754765AbYFBOKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 10:10:35 -0400
Date: Mon, 2 Jun 2008 14:54:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Pavel Machek <pavel@ucw.cz>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Theodore Tso <tytso@mit.edu>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
Message-ID: <20080602145458.011b3655@core>
In-Reply-To: <4843C1E0.3080900@garzik.org>
References: <20080508161008.59361de5@appleyard>
	<20080527030854.GC7515@mit.edu>
	<20080527143202.4bab5bf0@appleyard>
	<20080527225926.GE6843@mit.edu>
	<20080527163251.04054a74@appleyard>
	<20080531080015.GG5405@ucw.cz>
	<4842F5A8.9020708@garzik.org>
	<20080602080440.25fc663c@core>
	<4843A4A7.3020809@garzik.org>
	<20080602092225.26db9b5b@core>
	<4843C1E0.3080900@garzik.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > We don't need it per port Jeff, you are being quite silly here. Right now
> > its permanently foo=0 for all ports and nobody has suffered anything too
> > horrible so being able to turn it off for all ports is clearly quite
> > sufficient for the neat future.
> 
> Er, huh?  foo=0 means hotplug continues to work on the unused ports. 
> Nobody has suffered because we default to enabling all the goodies.

Thats a simple question of what "=0" means - is it "disable=1" or
"enable=1" or to quote Alice in Wonderland

	'When I use a word,' Humpty Dumpty said, in a rather scornful
	tone,' it means just what I choose it to mean, neither more nor
	less

It really doesn't matter if it is on by default or off by default,
whether 0 means off or on, what matters is that the single switch is
quite sufficient initially to improve matters for everyone wanting to use
the feature without harming anyone else.

Sure you might want to make it per port later but someone who wants to
optimise that peculiar case, has a problem and can test it can deal with
that.

Alan

