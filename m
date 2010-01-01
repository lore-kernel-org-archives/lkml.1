Return-Path: <linux-kernel-owner+w=401wt.eu-S1752007Ab0AASzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab0AASzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 13:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735Ab0AASzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 13:55:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47619 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab0AASzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 13:55:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andreas Mohr <andi@lisas.de>
Subject: Re: [PATCH] PCI / PM: Use per-device D3 delays
Date: Fri, 1 Jan 2010 19:55:27 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Maciej J. Woloszyk" <mat@esi.com.pl>
References: <20100101170729.GA22252@rhlx01.hs-esslingen.de>
In-Reply-To: <20100101170729.GA22252@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001011955.27407.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 January 2010, Andreas Mohr wrote:
> Hi,
> 
> While the bug report mentions "So it's just quirky hardware.",
> the implementation of your patch makes it seem like this delay attribute is
> totally "norm"al behaviour - I'm missing some more aggressive wording.

That's because it works both ways (please look at the changelog).

I know of a few devices that don't need the PCI-prescribed 10 ms wait when
going from D3 to D0 and their drivers may use the d3_delay field to actually
set a _shorter_ delay.

> Perhaps rename d3_delay to d3_delay__quirk or add something to the
> comment, like "D3->D0 transition time in ms (out-of-spec PCI device quirk)"?
> Or maybe something like
> "custom D3->D0 transition time in ms (for quirky hardware violating the PCI spec's <= 100ms)".
> 
> Thanks for your ongoing great PCI efforts,

You're welcome.

Rafael
