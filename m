Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZK3Ntf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZK3Ntf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 08:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZK3Nte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 08:49:34 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55048 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752230AbZK3Ntd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 08:49:33 -0500
Date: Mon, 30 Nov 2009 13:51:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Pierre Ossman <pierre@ossman.eu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Ben Hutchings <ben@decadent.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, 504391@bugs.debian.org,
       Wouter van Heyst <larstiq@larstiq.dyndns.org>
Subject: Re: [PATCH] mmc: add module parameter to set whether cards are
 assumed removable
Message-ID: <20091130135119.4bacade7@lxorguk.ukuu.org.uk>
In-Reply-To: <1259587966.13049.6.camel@maxim-laptop>
References: <1257914676.2237.57.camel@localhost>
	<20091116122329.847916b6.akpm@linux-foundation.org>
	<1258410709.2792.9.camel@localhost>
	<4B02565C.1030406@s5r6.in-berlin.de>
	<20091130133949.794fef00@mjolnir.ossman.eu>
	<1259587966.13049.6.camel@maxim-laptop>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Before we do suspend, pick few random sectors from the media, run that
> through some hash function, thus creating some sort of watermark.

Statistically speaking the chances are you'll catch zero sectors and
lose. You'll also not detect the suspend, move to other box, use, put
back error. That is one users make and we need to be at least vaguely
robust against.

Hence you need the fs checking here.

Alan
