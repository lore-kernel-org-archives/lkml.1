Return-Path: <linux-kernel-owner+w=401wt.eu-S1758194AbYEQBXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbYEQBXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 21:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYEQBW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 21:22:57 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:43979 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbYEQBW4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 21:22:56 -0400
From: Alok Kataria <akataria@vmware.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: "devzero@web.de" <devzero@web.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Date: Fri, 16 May 2008 18:22:52 -0700
Subject: RE: Kernel hangs in SMP + VMware environment.
Thread-Topic: Kernel hangs in SMP + VMware environment.
Thread-Index: Aci3Uxyd6THZHLaxThyTU5uq1n6qDQAaKKVj
Message-ID: <D3C12B2AD838B44DA9D6B2CA334246D00DC43DE5E6@PA-EXMBX04.vmware.com>
References: <1210789834.8798.20.camel@promb-2n-dhcp368.eng.vmware.com>
	<200805150611.m4F6Bv4J046219@www262.sakura.ne.jp>
	<D3C12B2AD838B44DA9D6B2CA334246D00D8F38DA60@PA-EXMBX04.vmware.com>,<200805162148.AAJ21381.QOSMOFFFLHOVJt@I-love.SAKURA.ne.jp>
In-Reply-To: <200805162148.AAJ21381.QOSMOFFFLHOVJt@I-love.SAKURA.ne.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


________________________________________
From: Tetsuo Handa [penguin-kernel@I-love.SAKURA.ne.jp]
Sent: Friday, May 16, 2008 5:48 AM
To: Alok Kataria
Cc: devzero@web.de; linux-kernel@vger.kernel.org; Daniel Hecht
Subject: Re: Kernel hangs in SMP + VMware environment.

Hello.

Alok Kataria wrote:
> Actually it would be better to use clocksource=acpi_pm on kernels which don't
> have this patch, as ACPI_PM comes with many more featuers like hrtimers,
> nohz, etc.
>
> On the other hand for kernels which have this patch attached,  it would be
> best to use TSC, for performance.
I see. Thanks.



I'm not sure, but this problem might exist in all kernels since 2.6.18 , for
I can find clocksource= parameter in Documentation/kernel-parameters.txt .

ANK> Sorry, but I dont understand what you are pointing to, the 2.6.18 kernel does
ANK> have clocksource parameter.
ANK> And you are correct this could be a problem with all the kernels which are
ANK> using clocksource.

I didn't experience this problem in earlier kernels (e.g. 2.6.20)
since I was running only 1 VMware guest at a time.

Today I ran 2 VMware guests simultaneously (one with kernel 2.6.22 and
the other with kernel 2.6.18, both are assigned 2 virtual CPUs) and I encountered
may-be-hanged-up with the 2.6.18 one.


ANK> If you are able to reproduce this with any of the kernels with the patch applied
ANK> Please let me know.

Thanks,
Alok

The Ctrl-C didn't work, the Alt-F? didn't work, the Ctrl-Alt-Del didn't work.
I had no time to reproduce it, so I'm not sure it has actually hanged up.

Regards.
