Return-Path: <linux-kernel-owner+w=401wt.eu-S1751630Ab0AARHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab0AARHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 12:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342Ab0AARHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 12:07:31 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:37482 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab0AARHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 12:07:30 -0500
Date: Fri, 1 Jan 2010 18:07:29 +0100
From: Andreas Mohr <andi@lisas.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Maciej J. Woloszyk" <mat@esi.com.pl>
Subject: Re: [PATCH] PCI / PM: Use per-device D3 delays
Message-ID: <20100101170729.GA22252@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While the bug report mentions "So it's just quirky hardware.",
the implementation of your patch makes it seem like this delay attribute is
totally "norm"al behaviour - I'm missing some more aggressive wording.

Perhaps rename d3_delay to d3_delay__quirk or add something to the
comment, like "D3->D0 transition time in ms (out-of-spec PCI device quirk)"?
Or maybe something like
"custom D3->D0 transition time in ms (for quirky hardware violating the PCI spec's <= 100ms)".

Thanks for your ongoing great PCI efforts,

Andreas Mohr
