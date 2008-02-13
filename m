Return-Path: <linux-kernel-owner+w=401wt.eu-S1763334AbYBMSrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763334AbYBMSrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbYBMSrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:47:40 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:52092 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754458AbYBMSrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:47:39 -0500
Date: Wed, 13 Feb 2008 19:47:40 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Shannon Nelson <shannon.nelson@intel.com>,
       David Brownell <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>
Subject: Re: [RFC v2 5/5] Atmel MCI: Driver for Atmel on-chip MMC
 controllers
Message-ID: <20080213194740.1e57b798@siona>
In-Reply-To: <20080213193051.1a7e3b29@poseidon.drzeus.cx>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-2-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-4-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-5-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-6-git-send-email-hskinnemoen@atmel.com>
	<20080213193051.1a7e3b29@poseidon.drzeus.cx>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 19:30:51 +0100
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> I think this was meant to go away.

> And this should go into the core.

> I also pointed this out. mmc_remove_host() will synchronize this for
> you.

Right. Sorry. I focused so much on getting the driver to work correctly
that I totally forgot about these things.

I'll fix it up before the next round (which I hope can be labeled
"PATCH" instead of "RFC".)

Btw, this isn't the latest version of the driver...but I'm afraid the
latest one suffers from these omissions too, except for the last one
which I did actually remove.

Haavard
