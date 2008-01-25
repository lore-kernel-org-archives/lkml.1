Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYAYQcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYAYQcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 11:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYAYQcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 11:32:03 -0500
Received: from hpsmtp-eml11.kpnxchange.com ([213.75.38.111]:3984 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752785AbYAYQcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 11:32:01 -0500
From: Frans Pop <elendil@planet.nl>
To: Jochen Friedrich <jochen@scram.de>
Subject: Re: [PATCH] [NET]: Remove PowerPC code from fec.c
Date: Fri, 25 Jan 2008 17:31:54 +0100
User-Agent: KMail/1.9.7
Cc: galak@kernel.crashing.org, geert@linux-m68k.org, gerg@uclinux.org,
       jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, scottwood@freescale.com,
       vitb@kernel.crashing.org
References: <4799F349.9090102@scram.de> <E1JIQpQ-0006Xj-RR@faramir.fjphome.nl> <479A087F.5010305@scram.de>
In-Reply-To: <479A087F.5010305@scram.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801251731.56378.elendil@planet.nl>
X-OriginalArrivalTime: 25 Jan 2008 16:31:56.0717 (UTC) FILETIME=[CD1B0DD0:01C85F6F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2008, Jochen Friedrich wrote:
> > Jochen Friedrich wrote:
> >> +++ b/drivers/net/fec.c
> >> @@ -23,6 +23,9 @@
> >>   *
> >>   * Bug fixes and cleanup by Philippe De Muyter (phdm@macqel.be)
> >>   * Copyright (c) 2004-2006 Macq Electronique SA.
> >> + *
> >> + * This driver is now only used on ColdFire processors. Remove conditional
> >> + * Powerpc code. 
> >>   */
> >
> > This comment makes sense for a changelog, but IMO it makes no sense at
> > all to add it to the file.
>
> I just added it to clarify this code is now only used on m68knommu
> (Coldfire). The comments on top are mailny about MPC860T CPUs (PowerPC),
> however the driver is no longer used for these CPUs.
>
> Maybe the wording should be changed to:
>
> This driver is now only used on ColdFire (m68knommu) processors.
> Conditional PowerPC code has been removed.

Yes, that certainly makes more sense, although IMHO the second sentence is
still somewhat redundant. (My problem was mainly with the second sentence.
I should have made that more clear, sorry.)
