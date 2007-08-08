Return-Path: <linux-kernel-owner+w=401wt.eu-S935025AbXHHPMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935025AbXHHPMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765338AbXHHPL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:11:56 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:2598 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764328AbXHHPLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:11:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iY5jqH65n57wbfh7q+k06U0v+mCIaQ3FtcwvUfC2tYjq/HvYkS0+VygpXEA6LseIuMcbGi4m+VLNxCdyS14UmptJMlWHGg+BF1qb3cN3Dg2wcBXs3ExCK0HFfnjCVH61jgD165L2mPBWbvrr4/lslhR8c5n3IwHIA5Z4msUMOtE=
Message-ID: <851fc09e0708080811l1e17255ctef617d9137a8c045@mail.gmail.com>
Date: Wed, 8 Aug 2007 23:11:54 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Chandramouli Narayanan" <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200708081609.33098.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9D7649D18729DE4BB2BD7B494F7FEDC246DC2B@pdsmsx415.ccr.corp.intel.com>
	 <200708081609.33098.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Andi Kleen <ak@suse.de> wrote:
> > Instead, elilo collects the needed information
> > defined in include/asm-x86_64/bootsetup.h itself,
>
> That's nasty. I must have missed when we declared this a public ABI.
> It's not really designed to be one. Was there public discussion on this?

Maybe What I said is not clear and correct. In fact, the elilo follows
the boot protocol defined in Documentation/i386/zero-page.txt, just
not uses arch/(i386|x86_64)/boot/setup.S to collect the information,
but collects them by elilo itself. Information in
include/asm-x86_64/bootsetup.h is just a part of that in
Documentation/i386/zero-page.txt.

> I expect we'll have some grief from this in the future.
>
> If it's really done this way we should at least add a version
> number and a boot loader ID like the standard boot protocol
> so that bugs later can be worked around. Also some Documentation
> would be good. And comments. But discussion first.
>

Is what defined in Documentation/i386/zero-page.txt the standard boot
protocol. If it is, the elilo follows it. My previous expressing is
not clear and correct.

Best Regards,
Huang Ying
