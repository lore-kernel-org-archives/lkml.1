Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbYGHXHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbYGHXHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbYGHXHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:07:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59209 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752638AbYGHXHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:07:06 -0400
Date: Tue, 8 Jul 2008 23:34:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Altobelli, David" <david.altobelli@hp.com>
Cc: Pavel Machek <pavel@suse.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Subject: Re: [PATCH][resubmit] HP iLO driver
Message-ID: <20080708233417.6fff4672@the-village.bc.nu>
In-Reply-To: <CF70AA892F109448AEA269483B3A983903BB8CF552@G1W1215.americas.hpqcorp.net>
References: <20080623160052.GA7616@ldl.fc.hp.com>
	<20080627191458.GA10872@ucw.cz>
	<CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net>
	<20080707160658.GB1794@elf.ucw.cz>
	<CF70AA892F109448AEA269483B3A983903BB8CEA25@G1W1215.americas.hpqcorp.net>
	<20080708072152.GD1761@elf.ucw.cz>
	<20080708073818.GA14245@elf.ucw.cz>
	<CF70AA892F109448AEA269483B3A983903BB8CEFC4@G1W1215.americas.hpqcorp.net>
	<20080708215002.GA18195@elf.ucw.cz>
	<CF70AA892F109448AEA269483B3A983903BB8CF552@G1W1215.americas.hpqcorp.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Unfortunately, I don't believe that I can.  We reviewed this internally,
> and the question of documentation was raised.  The hardware teams did
> not approve disseminating the ABI.  To be clear, we understand what we

Well I suggest that when you've sorted out the internal politics in HP
*then* you resubmit the driver code with more info.

> > We are not _that_ extreme. Yes, keep stuff in userspace is important,
> > but "hide hardware differences" is more important goal.
> 
> That seems like a larger question/goal.  Giving users some consistent
> interfaces to do stuff would be nice, but I'd really like to handle this
> driver on its own.

We need to sort out the interface to merge a set of drivers and produce a
common sensible interface that exposes commonality properly. It's rather
hard to do that when you won't provide any relevant information.

Alan
