Return-Path: <linux-kernel-owner+w=401wt.eu-S1762235AbXF0QXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762235AbXF0QXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757708AbXF0QWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:22:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:61455 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbXF0QWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:22:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,467,1175497200"; 
   d="scan'208";a="243999049"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Wed, 27 Jun 2007 09:22:05 -0700
User-Agent: KMail/1.9.7
Cc: Mauro Giachero <mauro.giachero@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <200706251434.43863.jesse.barnes@intel.com> <200706270804.53263.jesse.barnes@intel.com> <468289A1.3080709@macroscoop.nl>
In-Reply-To: <468289A1.3080709@macroscoop.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706270922.05801.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 27, 2007 9:00:33 Pim Zandbergen wrote:
> Jesse Barnes wrote:
> > Yeah, you're right I should use an unsigned format string.  Pim, if
> > you change it to %lu does the printk in your dmesg look better?
>
> Er, no.
>
> **** MTRRs don't cover all of memory, trimmed 18446744073709486080
> pages

It looks like end_pfn might be ~0UL now... can you print that out in 
your configuration?

Thanks,
Jesse
