Return-Path: <linux-kernel-owner+w=401wt.eu-S1751764AbXB0SxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbXB0SxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 13:53:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbXB0SxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 13:53:13 -0500
Received: from gw.goop.org ([64.81.55.164]:49002 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbXB0SxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 13:53:11 -0500
Message-ID: <45E47E14.2010608@goop.org>
Date: Tue, 27 Feb 2007 10:53:08 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [patch 05/26] Xen-paravirt_ops: paravirt_ops: hooks to set up
 initial pagetable
References: <20070227081337.434798469@goop.org> <20070227081630.650554241@goop.org> <20070227100942.GB10827@elte.hu>
In-Reply-To: <20070227100942.GB10827@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> ===================================================================
>> --- a/include/asm-i386/pgtable.h
>> +++ b/include/asm-i386/pgtable.h
>> @@ -15,7 +15,10 @@
>>  #include <asm/processor.h>
>>  #include <asm/fixmap.h>
>>  #include <linux/threads.h>
>> +
>> +#ifdef CONFIG_PARAVIRT		/* guarded to prevent cyclic dependency */
>>  #include <asm/paravirt.h>
>> +#endif
>>     
>
> avoid the cyclic dependency to begin with?

I'll try again, but as you know, the headers in this area are a hairy
tangle.

    J
