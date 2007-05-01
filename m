Return-Path: <linux-kernel-owner+w=401wt.eu-S1423504AbXEAX1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423504AbXEAX1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 19:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161717AbXEAX1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 19:27:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:2618 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161382AbXEAX1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 19:27:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,475,1170662400"; 
   d="scan'208";a="222682601"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] support PCI MCFG space on Intel i915 bridges
Date: Tue, 1 May 2007 16:27:14 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <fa.aWIs6SNmpl2IhGAAoSWJu6oKjPo@ifi.uio.no> <200704301225.22016.jesse.barnes@intel.com> <463679A4.60704@shaw.ca>
In-Reply-To: <463679A4.60704@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705011627.14948.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 30, 2007 4:20 pm Robert Hancock wrote:
> > Right, but you patch should obsolete this stuff anyway.  I'll test
> > it out in the next few days.
>
> We likely still want this chipset-specific support, it will catch the
> case where the MCFG table lists a location which is reserved in ACPI
> but the chipset was actually programmed to a different location
> entirely, which I seem to remember someone mentioning was actually
> the case on some boards..

Yeah, I suppose that's true.  So maybe your new checking code should 
leverage the stuff in mmconfig-shared.c to check against the register 
values like Olivier mentioned?

Jesse
