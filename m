Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbZIATgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbZIATgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 15:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbZIATgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 15:36:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48466 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbZIATgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 15:36:41 -0400
Date: Tue, 1 Sep 2009 16:36:04 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: linux-media <linux-media@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PULL] http://kernellabs.com/hg/~mkrufky/sms1xxx
Message-ID: <20090901163604.04599211@pedra.chehab.org>
In-Reply-To: <303a8ee30909010803r69f18fa0n8d40f164cf51607f@mail.gmail.com>
References: <20090730200714.5a7ab8a6@pedra.chehab.org>
	<20090801014053.7f53da83@pedra.chehab.org>
	<303a8ee30908011103n3c12258icd2bfd1305b419d3@mail.gmail.com>
	<20090811140128.211d4d11@caramujo.chehab.org>
	<37219a840908111457o4b6abc64n52291f044b56782d@mail.gmail.com>
	<37219a840908241332w2e2d45d8kd6406de3e60d1317@mail.gmail.com>
	<303a8ee30908300553s6d81a2cdn43145de51298afd5@mail.gmail.com>
	<20090830191325.45cf1e69@pedra.chehab.org>
	<303a8ee30908310403x73d067rd58d01fbd4fde299@mail.gmail.com>
	<20090901104731.5f119d53@pedra.chehab.org>
	<303a8ee30909010803r69f18fa0n8d40f164cf51607f@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 1 Sep 2009 11:03:14 -0400
Michael Krufky <mkrufky@kernellabs.com> escreveu:

> The Kconfig symbol names were changed, the target object has changed,
> the module filename has changed.
> 
> A submenu was added, the USB support is not enabled by default.
> 
> None of the above fixed any bug, it just makes unnecessary changes
> that are inappropriate this late in a kernel development cycle.

None of the above breaks anything, and enabling a driver by default is not good
anyway.

> If a bug needed to be fixed, it would have been as simple as adding
> the new object file for smssdio.o , and the old
> DVB_SIANO_SMS1XXX_SMS_IDS section could have been removed without
> changing everything.
> 
> I think this is ridiculous to slip in at the last moment, but I would
> have had no complaints seeing this in the next merge window.
> 
> What is the point of a "merge window" if you let people make such
> changes as this right before a kernel is released.

The patch is a bug fix and it is even older than your LED fix. The first
version were submitted before the previous merge window, and you asked for some
changes that were done accordingly. 

Since the entire Siano driver suffered major changes at the last merge window,
this patch needs to be available together with the remaining series of the
Siano series of patches, to reflect the changes that happened inside the
driver, and the inclusion of the SDIO driver.



Cheers,
Mauro
