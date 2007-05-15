Return-Path: <linux-kernel-owner+w=401wt.eu-S1759445AbXEOUvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445AbXEOUvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 16:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbXEOUvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 16:51:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:9248 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbXEOUvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 16:51:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,538,1170662400"; 
   d="scan'208";a="245990022"
Message-ID: <464A1D35.8030701@intel.com>
Date: Tue, 15 May 2007 13:51:01 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de
CC: Peter Oruba <peter.oruba@amd.com>, cramerj@intel.com,
       john.ronciak@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, rolandd@cisco.com, halr@voltaire.com,
       linux-driver@qlogic.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH 0/2] PCI-X/PCI-Express read control interfaces
References: <200705151350.28330.peter.oruba@amd.com> <20070515123721.1bfb02a3.akpm@linux-foundation.org>
In-Reply-To: <20070515123721.1bfb02a3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 May 2007 20:51:02.0800 (UTC) FILETIME=[BFF4D100:01C79732]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 15 May 2007 13:50:27 +0200
> "Peter Oruba" <peter.oruba@amd.com> wrote:
> 
>> This patch set introduces a PCI-X / PCI-Express read byte count control 
>> interface. Instead of letting every driver to directly read/write to PCI 
>> config space for that, an interface is provided. The interface functions then 
>> can be used for quirks since some PCI bridges require that read byte count 
>> values are set by the BIOS and left unchanged by device drivers.
> 
> Some of the patches were wordwrapped, which I fixed.
> 
> The way we would merge a feature like this is
> 
> - get maintainers to review-and-ack the change
> 
> - merge the core patch into Greg's PCI tree and later into
>   mainline.
> 
> - Once the base infrastructure is in mainline, feed the per-driver
>   changes into the tree via the appropriate maintainers.
> 
> This takes, umm, months and consumes quite a bit of my time.  I'm becoming
> inclined just to slam stuff like this straight in as you've proposed, but
> for now, let's play the game - I split the patches up appropriately.  I
> don't think there's any particular urgency behind this, is there?

While Jeff just Acked the changes to e1000-specific for me, I think this is a 
good approach and would appreciate it. I'll be happy to pull the change and push 
it through in due time.

Auke

