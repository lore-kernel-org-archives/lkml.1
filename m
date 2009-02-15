Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbZBOQoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbZBOQoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 11:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbZBOQoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 11:44:20 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:13884 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753182AbZBOQoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 11:44:19 -0500
X-Trace: 146811577/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.250/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.250
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: SquirrelMail/1.4.15
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEAKbUl0lQLLD6/2dsb2JhbACBbs05hBwG
X-IronPort-AV: E=Sophos;i="4.38,211,1233532800"; 
   d="scan'208";a="146811577"
Message-ID: <936fa6a7e76b86c08b843b6531d27861.squirrel@newgolddream.dyndns.info>
In-Reply-To: <20090215150335.GA15736@ioremap.net>
References: <1234646219.6609.37.camel@localhost.localdomain>
    <20090215150335.GA15736@ioremap.net>
Date: Sun, 15 Feb 2009 16:43:52 -0000 (UTC)
Subject: Re: [RFC][PATCH] filesystem: VMUFAT filesystem
From: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, February 15, 2009 3:03 pm, Evgeniy Polyakov wrote:
> Hi Adrian.


Hi
>
> That's all for now. Overall there is a fair numebr of leaks
> because of the missed freeing in the error path and lots of duplicated
> code because of the multiple error exit points. Also you frequently do
> not check the return value of the functions which may fail.
>
> --
> 	Evgeniy Polyakov
>

Thanks for the comments. Very useful. I ported this over from some truly
abysmal code I'd written years ago and clearly didn't do a good enough job
:)

