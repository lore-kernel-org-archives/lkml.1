Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbZCCIzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbZCCIzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 03:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZCCIzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 03:55:36 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:53448 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbZCCIzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 03:55:36 -0500
Date: Tue, 3 Mar 2009 09:55:30 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: =?UTF-8?B?SsO2cmc=?= Schummer <ext-jorg.2.schummer@nokia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT] MMC: core/core.c: mmc_rescan detects card change in
 one run
Message-ID: <20090303095530.65923117@mjolnir.ossman.eu>
In-Reply-To: <1236065059.5791.34.camel@jorg-desktop>
References: <1235057186-31714-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	<20090302210945.04bfa623@mjolnir.ossman.eu>
	<1236065059.5791.34.camel@jorg-desktop>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Mar 2009 09:24:19 +0200
Jörg Schummer <ext-jorg.2.schummer@nokia.com> wrote:

> > 
> > The else section got a bit small here with that code removed. Perhaps
> > we should instead have:
> > 
> > 	if (host->bus_ops != NULL) {
> > 		mmc_bus_put(host);
> > 		goto out;
> > 	}
> 
> I guess you meant
> 
> 	else {
> 		mmc_bus_put(host);
> 		goto out;
> 	}
> 
> since it would be the else clause of
> 
> 	if (host->bus_ops == NULL)
> 

No, I meant to put it further up and unindent the detection code.
Basically you'll be reversing the if-else blocks, but using a goto
instead of an else.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
