Return-Path: <linux-kernel-owner+w=401wt.eu-S1761678AbZFNNxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761678AbZFNNxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 09:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbZFNNxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 09:53:14 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:42907 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbZFNNxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 09:53:14 -0400
Date: Sun, 14 Jun 2009 21:51:47 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       JosephChan@via.com.tw, Bruce Chang <BruceChang@via.com.tw>
Subject: Re: [PATCH] mmc: Add new via-sdmmc host controller driver
Message-ID: <20090614135147.GQ2854@prithivi.gnumonks.org>
References: <20090612075930.GB30843@prithivi.gnumonks.org> <20090613134328.0c168205@mjolnir.ossman.eu> <20090614065256.GJ2854@prithivi.gnumonks.org> <20090614125537.065d706a@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090614125537.065d706a@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 12:55:37PM +0200, Pierre Ossman wrote:

> > Also, you stated that mmc_remove_host needs to be the first step.  However,
> > sdhci first kills the ongoing rquest (if "dead"), and then removes the host.
> 
> Right, because the reason you need to end the request is that failure
> to do so will wedge the MMC system and mmc_remove_host() will never
> return.
> 
> Normally the requests will eventually be completed by interrupts coming
> from the hardware, but if it got removed then that might not happen.

Ok, I will copy+paste the snippet from sdhci.c and do some testing, both
removing the card while continuously issuing requests, as well as removing the
driver while doing that.

Will submit the result again in two days or so.

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
