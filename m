Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYGXPnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYGXPnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYGXPnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:43:00 -0400
Received: from mga07.intel.com ([143.182.124.22]:56989 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751727AbYGXPm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:42:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,247,1215414000"; 
   d="scan'208";a="24355616"
Message-ID: <4888A300.1080808@linux.intel.com>
Date: Thu, 24 Jul 2008 08:42:56 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: linux-acpi <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <lenb@kernel.org>,
       Christian Kornacker <ckornacker@suse.de>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature
 shutdowns
References: <200807241727.41715.trenn@suse.de>
In-Reply-To: <200807241727.41715.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Renninger wrote:
> This is the fix for this from Arjan:
> 
>     ACPI: Reject below-freezing temperatures as invalid critical temperatures
> 
>     My laptop thinks that it's a good idea to give -73C as the critical
>     CPU temperature.... which isn't the best thing since it causes a shutdown
>     right at bootup.
> 
>     Temperatures below freezing are clearly invalid critical thresholds
>     so just reject these as such.
> 

btw on my laptop, it wasn't 0 that was returned, but 2007.
This is suspected to be related to how windows finds some random other ACPI state to return,
but it significantly was an AML issue on the bios side.
Just the effect was a trainwreck so I added a check to the kernel (in addition to getting
full info to Robert for the ACPICA side of the issue).

