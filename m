Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbXICMyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbXICMyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 08:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbXICMxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 08:53:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:42763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbXICMxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 08:53:24 -0400
From: Andi Kleen <ak@suse.de>
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space access for AMD Barcelona
Date: Mon, 3 Sep 2007 14:52:45 +0200
User-Agent: KMail/1.9.1
Cc: "Robert Richter" <robert.richter@amd.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
References: <20070830174311.221133000@amd.com> <200709031215.03473.ak@suse.de> <20070903113114.GA22086@alberich.amd.com>
In-Reply-To: <20070903113114.GA22086@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709031452.45434.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> And unfortunately this is too often the case.

On Barcelona systems? 

> See for instance Robert Hancock's patch http://lkml.org/lkml/2007/5/30/2
> to enable MMCONFIG access in certain cases where BIOS did not correctly
> set up MCFG. Why are people working on such stuff if it is not serious
> enough?

I don't know why. I'm just not aware of any serious problems that
are solved by extended config space access.

Originally we had trouble because MCFG was wrong and the systems
would not boot. Also there is one class of systems (some x86 Apples) 
where cf8 doesn't work, but MMCONFIG does.
But that's all specific to older systems. 

> Barcelona just adds another way to access PCI ECS (besides MMCONFIG) and I
> can't understand why this shouldn't be supported by Linux.

It will be supported when the BIOS gets it right.

> Do you have any suggestion how else to add support for PCI ECS access via
> IO instructions for Barcelona?

My suggestion is to rely on MMCONFIG for this.

-Andi
