Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbXIDHXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbXIDHXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 03:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbXIDHXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 03:23:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbXIDHXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 03:23:05 -0400
From: Andi Kleen <ak@suse.de>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space access for AMD Barcelona
Date: Tue, 4 Sep 2007 08:20:47 +0100
User-Agent: KMail/1.9.1
Cc: "Robert Richter" <robert.richter@amd.com>, patches@x86-64.org,
       "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       linux-kernel@vger.kernel.org
References: <20070830174311.221133000@amd.com> <200709031448.42285.ak@suse.de> <86802c440709032354w46395c72m954e53b5685be11e@mail.gmail.com>
In-Reply-To: <86802c440709032354w46395c72m954e53b5685be11e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709040820.47444.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> for setting mmio to accessing pci conf space, need to set sth on MSR.
> So the BIOS need to make it right..., otherwise OS need to set that
> when booting every cpu...to workaround it to make MMCONFIG working.

Yes the BIOS has to get some things right. After all that's the BIOS job.
And the BIOS knows much more about the hardware than the generic
kernel.  x86 Linux is not trying to be a BIOS too.

-Andi
