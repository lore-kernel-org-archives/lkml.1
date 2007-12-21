Return-Path: <linux-kernel-owner+w=401wt.eu-S1760601AbXLUOcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbXLUOcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 09:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbXLUOci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 09:32:38 -0500
Received: from mga05.intel.com ([192.55.52.89]:37554 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750920AbXLUOch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 09:32:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,194,1196668800"; 
   d="scan'208";a="453573560"
Message-ID: <476BCE15.6090902@linux.intel.com>
Date: Fri, 21 Dec 2007 15:30:45 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       Marcel Holtmann <marcel@holtmann.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: Top 10 kernel oopses/warnings for the week of December 21st 2007
References: <476BA8AF.4060201@linux.intel.com> <p73ejdgf8vj.fsf@bingen.suse.de>
In-Reply-To: <p73ejdgf8vj.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Arjan van de Ven <arjan@linux.intel.com> writes:
> 
>> 	
>> Rank 8: __change_page_attr
>> 	BUG at arch/x86/mm/pageattr_64.c:176
>> 	Reported 2 times
>> 	Reported this week for 2.6.24-rc5; history goes back to 2.6.15
> 
> There is no BUG on this line on 2.6.24-rc5.   Since there are many
> BUG_ONs in this file it is unclear which you mean.
> 
> Could you always include the version of the kernel where the actual
> oops in the line came from?

in this case this is really all the version information available ;(
it seems to be a patched kernel without patched EXTRAVERSION.
But in the future if I have more specific information (eg it's only 1 kernel version) I'll mention it in more detail.
It gets unwieldy if there's 500 reports for an oops of course ;)

> 
> Anyways there are a lot of third party modules who do strange 
> things with c_p_a(), not always legal, so you might look up out for that 
> pattern too. Perhaps report the out of tree modules loaded in the 
> summary too?

I already always will mention if the oops is tainted or not (that I track specifically);
I'll keep an eye out for other non-tainting out of tree modules as well.

Thanks for the suggestions.

