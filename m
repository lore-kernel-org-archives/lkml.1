Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbYBOQeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbYBOQeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 11:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYBOQd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 11:33:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:9680 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681AbYBOQd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 11:33:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,358,1199692800"; 
   d="scan'208";a="519234238"
Message-ID: <47B5BDC0.3020003@intel.com>
Date: Fri, 15 Feb 2008 08:28:48 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jdike@addtoit.com,
       jack@suse.cz
Subject: Re: 2.6.24-mm1 bugs
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu>
In-Reply-To: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Feb 2008 16:29:40.0971 (UTC) FILETIME=[F6DE9BB0:01C86FEF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>  - network doesn't always come up at first try (e1000e).  On 2.6.24
>    e1000e doesn't seem to work at all, so I use e1000, but that has
>    other problems.

Andy Gospodarek pointed out a possible problem with e1000e if you are not using
MSI interrupts (e.g. booting with pci=nomsi or CONFIG_PCI_MSI=n). Can you confirm
that you are not using MSI irqs? If so, then we have a patch that you can try.

IOW post your `cat /proc/interrupts` please :)

Auke
