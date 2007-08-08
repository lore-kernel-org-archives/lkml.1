Return-Path: <linux-kernel-owner+w=401wt.eu-S934554AbXHHOJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934554AbXHHOJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763113AbXHHOJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:09:40 -0400
Received: from ns2.suse.de ([195.135.220.15]:42543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759864AbXHHOJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:09:39 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
Date: Wed, 8 Aug 2007 16:09:32 +0200
User-Agent: KMail/1.9.6
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Chandramouli Narayanan" <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
References: <9D7649D18729DE4BB2BD7B494F7FEDC246DC2B@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <9D7649D18729DE4BB2BD7B494F7FEDC246DC2B@pdsmsx415.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081609.33098.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Instead, elilo collects the needed information
> defined in include/asm-x86_64/bootsetup.h itself, 

That's nasty. I must have missed when we declared this a public ABI.
It's not really designed to be one. Was there public discussion on this?

I expect we'll have some grief from this in the future.

If it's really done this way we should at least add a version
number and a boot loader ID like the standard boot protocol
so that bugs later can be worked around. Also some Documentation
would be good. And comments. But discussion first.

-Andi

