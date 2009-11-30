Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbZK3Mqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbZK3Mqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 07:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZK3Mqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 07:46:49 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52591 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752812AbZK3Mqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 07:46:48 -0500
Date: Mon, 30 Nov 2009 12:48:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "504391@bugs.debian.org" <504391@bugs.debian.org>,
       Wouter van Heyst <larstiq@larstiq.dyndns.org>
Subject: Re: [PATCH] mmc: add module parameter to set whether cards are
 assumed removable
Message-ID: <20091130124844.6ec0b8da@lxorguk.ukuu.org.uk>
In-Reply-To: <4B13BCD1.9040000@nokia.com>
References: <1257914676.2237.57.camel@localhost>
	<4B13BCD1.9040000@nokia.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You do not cater for having more than one slot e.g. N900 has two:
> one internal non-removable and one external that is removable.
> 
> What about a sysfs entry instead e.g.
> 
>  /sys/class/mmc-host/mmc*/nonremovable

That continues the assumption that the user will somehow ever know about
this stuff and configure it. Almost nobody will.

Not only does it need to be per-port there needs to be a credible
description of how it will automatically happen - who configures it,
when, how and is the data needed available.

