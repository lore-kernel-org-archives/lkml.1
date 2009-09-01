Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbZIANsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbZIANsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbZIANsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:48:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51009 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbZIANsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:48:08 -0400
Date: Tue, 1 Sep 2009 10:47:31 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: linux-media <linux-media@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PULL] http://kernellabs.com/hg/~mkrufky/sms1xxx
Message-ID: <20090901104731.5f119d53@pedra.chehab.org>
In-Reply-To: <303a8ee30908310403x73d067rd58d01fbd4fde299@mail.gmail.com>
References: <20090730200714.5a7ab8a6@pedra.chehab.org>
	<37219a840907310825n51d5a6bar79ea1f31dd889327@mail.gmail.com>
	<20090801014053.7f53da83@pedra.chehab.org>
	<303a8ee30908011103n3c12258icd2bfd1305b419d3@mail.gmail.com>
	<20090811140128.211d4d11@caramujo.chehab.org>
	<37219a840908111457o4b6abc64n52291f044b56782d@mail.gmail.com>
	<37219a840908241332w2e2d45d8kd6406de3e60d1317@mail.gmail.com>
	<303a8ee30908300553s6d81a2cdn43145de51298afd5@mail.gmail.com>
	<20090830191325.45cf1e69@pedra.chehab.org>
	<303a8ee30908310403x73d067rd58d01fbd4fde299@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 31 Aug 2009 07:03:18 -0400
Michael Krufky <mkrufky@kernellabs.com> escreveu:

> I see the GPIO fix in your git tree now -- Thanks for merging it.
> 
> However, I also see this changeset:
> 
> http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-2.6.git;a=commitdiff;h=31e0ad693fb4e1d1be19dbe1c4f5a1ab9978e810
> 
> I believe that it is way too late in 2.6.31 to merge a changeset like
> this -- Please revert that and if there is actually a Kconfig change
> required, merge a more minimal change for 2.6.31 and hold off this
> huge, risky change for the next merge window.
> 
> There is not enough time to fix this, if this changeset causes
> additional breakage.

This is just Kbuild changes, and it is there at linux-next for some time,
where for sure people already tried to do several different building tests.
Among some cosmetics, it removes a dead symbol (DVB_SIANO_SMS1XXX_SMS_IDS).

It is very bad to expose to the user a config option that configs nothing.

Anyway, Linus already merged the pull request. If you eventually find a bug on
it, please ping me for us to send a fix.

Cheers,
Mauro
