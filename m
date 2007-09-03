Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbXICPYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbXICPYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 11:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbXICPYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 11:24:48 -0400
Received: from ns1.suse.de ([195.135.220.2]:38393 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbXICPYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 11:24:47 -0400
From: Andi Kleen <ak@suse.de>
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space access for AMD Barcelona
Date: Mon, 3 Sep 2007 16:24:09 +0100
User-Agent: KMail/1.9.1
Cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
References: <20070830174311.221133000@amd.com> <200709031448.42285.ak@suse.de> <20070903144842.GK7916@erda.amd.com>
In-Reply-To: <20070903144842.GK7916@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709031624.09681.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 September 2007 15:48, Robert Richter wrote:
> Andi,
>
> On 03.09.07 14:48:41, Andi Kleen wrote:
> > > As said above, I do not see CF8 access as a workaround. I expect my
> > > system to work in the same way also if MMCONFIG is not available.
> >
> > It should boot sure, but exotic stuff not working is not a major issue
>
> It is not only about booting the system without MMCONFIG, it is also
> about using the system

There are limits on how many BIOS bug workaround (and all this
patch kit is nothing more than a elaborate BIOS bug workaround) we can do.
IMHO you're far exceeding the threshold.

Better would be to invest that energy to get the BIOSes fixed.

> . For this PCI ECS CF8 access is needed.

AER and IBS are all totally optional features and the systems
will be completely usable without them.

-Andi
