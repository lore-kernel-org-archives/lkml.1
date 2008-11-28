Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYK1H3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYK1H3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 02:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbYK1H26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 02:28:58 -0500
Received: from mail.hevs.ch ([153.109.23.10]:41876 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYK1H26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 02:28:58 -0500
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] mmc: at91_mci: reorder timer setup and mmc_add_host() call
Date: Fri, 28 Nov 2008 08:28:49 +0100
User-Agent: KMail/1.9.9
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Pierre Ossman <drzeus@drzeus.cx>,
       wux@landicorp.com, Andrew Victor <linux@maxim.org.za>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <492EC995.8050701@atmel.com>
In-Reply-To: <492EC995.8050701@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811280828.50942.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2008, Nicolas Ferre wrote:
> As said in function comment mmc_add_host() requires that:
> "The host must be prepared to start servicing requests
> before this function completes."
> 
> During this function, at91_mci_request() can be invoqued
> without timer beeing setup leading to a kernel Oops.
> This has been reported inserting this driver as a module.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Reported-by: Wu Xuan <wux@landicorp.com>

Bug introduced by me ;)

Ack

Best regards

Marc
