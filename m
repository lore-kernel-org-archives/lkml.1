Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbYBYWwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbYBYWwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760959AbYBYWvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:51:48 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:27452 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760835AbYBYWvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:51:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=s1hiLLsbYdZMeNwTIDbSlEXEaCw9Jxu5EP6Oo7zuYV3m9OiAAtxmqGoyFUj9WgoYkZpi9aVSURkyehnlLNIYHpGNuHDOYjK9lHcn2Toa4zDonDmu3g5J+M9MtXnhiYVXSol0OSYC/11o+QxzXpyWZF/iqpD9PT/oVPqKRfg1cC0=
Message-ID: <31e679430802251451y3ae370ddj125616ee4e655536@mail.gmail.com>
Date: Tue, 26 Feb 2008 00:51:43 +0200
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>, carlos.aguiar@indt.com.br
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card is inserted]
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
       "David Brownell" <david-b@pacbell.net>,
       "Kernel development list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080225184102.0a2e2bb5@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802241500.41969.rjw@sisk.pl>
	 <Pine.LNX.4.44L0.0802240941440.29504-100000@netrider.rowland.org>
	 <20080225184102.0a2e2bb5@mjolnir.drzeus.cx>
X-Google-Sender-Auth: da238f4b8cc7d136
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>

> > What's the purpose of the card-counting loop in
> > host/omap.c:mmc_omap_switch_handler()? It looks like dead code.
> >
>
> I'm not too familiar with that driver, but they've been playing around
> with multiplexing several cards into one controller. Might be bits and
> pieces of that.
>

AFAIK, that came after mmc multislot support. Omap2 has one mmc
controller  for several (2 in practice) mm slots (cards).
It's not really a dead code since it's used in n800 and n810, it's in
linux-omap archives and git tree.

Carlos Aguiar, added in the loop, might have some comments about it.

--
Best Regards,
Felipe Balbi
felipebalbi@users.sourceforge.net
