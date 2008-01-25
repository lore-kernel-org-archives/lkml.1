Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbYAYPvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbYAYPvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 10:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbYAYPu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 10:50:59 -0500
Received: from hpsmtp-eml13.KPNXCHANGE.COM ([213.75.38.113]:5477 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753886AbYAYPu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 10:50:58 -0500
To: Jochen Friedrich <jochen@scram.de>
Subject: Re: [PATCH] [NET]: Remove PowerPC code from fec.c
Cc: galak@kernel.crashing.org, geert@linux-m68k.org, gerg@uclinux.org,
       jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, scottwood@freescale.com,
       vitb@kernel.crashing.org
In-reply-To: <4799F349.9090102@scram.de>
References: <4799F349.9090102@scram.de>
Message-Id: <E1JIQpQ-0006Xj-RR@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Fri, 25 Jan 2008 16:50:52 +0100
X-OriginalArrivalTime: 25 Jan 2008 15:50:55.0139 (UTC) FILETIME=[11E40F30:01C85F6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jochen Friedrich wrote:
> +++ b/drivers/net/fec.c
> @@ -23,6 +23,9 @@
>   *
>   * Bug fixes and cleanup by Philippe De Muyter (phdm@macqel.be)
>   * Copyright (c) 2004-2006 Macq Electronique SA.
> + *
> + * This driver is now only used on ColdFire processors. Remove conditional
> + * Powerpc code. 
>   */

This comment makes sense for a changelog, but IMO it makes no sense at all
to add it to the file.

Cheers,
FJP
