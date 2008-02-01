Return-Path: <linux-kernel-owner+w=401wt.eu-S933303AbYBAFCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303AbYBAFCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757410AbYBAEzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:55:14 -0500
Received: from mga10.intel.com ([192.55.52.92]:2477 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934997AbYBAEzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:55:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,288,1199692800"; 
   d="scan'208";a="294811655"
Message-ID: <47A2A5D8.4080700@linux.intel.com>
Date: Thu, 31 Jan 2008 20:53:44 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jiri Slaby <jirislaby@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Dominik Brodowski <linux@brodo.de>, Andi Kleen <ak@suse.de>,
       Adrian Bunk <bunk@stusta.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Nick Piggin <npiggin@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <len.brown@intel.com>
Subject: Re: Feature Removals for 2.6.25
References: <1201829922.23523.68.camel@brick>
In-Reply-To: <1201829922.23523.68.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> ---------------------------
> 
> What:	CONFIG_FORCED_INLINING
> When:	June 2006
> Why:	Config option is there to see if gcc is good enough. (in january
>         2006). If it is, the behavior should just be the default. If it's not,
> 	the option should just go away entirely.
> Who:    Arjan van de Ven
> 
> Patch submitted to Arjan, maybe 2.6.25?

Ingo picked it up, but no rush for .25, .26 is fine for this as well

> 
> What:	Unused EXPORT_SYMBOL/EXPORT_SYMBOL_GPL exports
> 	(temporary transition config option provided until then)
> 	The transition config option will also be removed at the same time.
> When:	before 2.6.19
> Why:	Unused symbols are both increasing the size of the kernel binary
> 	and are often a sign of "wrong API"
> Who:	Arjan van de Ven <arjan@linux.intel.com>

this is an ongoing work; symbols get marked unused and then garbage collected
when they're due; for example akpm has several of that kind in his pile right now
