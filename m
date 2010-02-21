Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab0BUVCL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 16:02:11 -0500
Received: from mga03.intel.com ([143.182.124.21]:32371 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab0BUVCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 16:02:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,512,1262592000"; 
   d="scan'208";a="246414992"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@infradead.org>
Date: Sun, 21 Feb 2010 13:02:19 -0800
Subject: RE: What's the right value for idle= (was: Re: [linux-pm]
 regression on P-II SMP)
Thread-Topic: What's the right value for idle= (was: Re: [linux-pm]
 regression on P-II SMP)
Thread-Index: AcqzNWpNFsbzVWwvTU653Kc/aTgrPAAA0QCQ
Message-ID: <7C53B33EE871F14797C999838AA8B5A9143F39E1@orsmsx505.amr.corp.intel.com>
References: <Pine.LNX.4.64.1002212117540.9624@axis700.grange>
 <201002212136.03783.rjw@sisk.pl>
In-Reply-To: <201002212136.03783.rjw@sisk.pl>
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

 

>-----Original Message-----
>From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
>Sent: Sunday, February 21, 2010 12:36 PM
>To: Guennadi Liakhovetski
>Cc: linux-pm@lists.linux-foundation.org; LKML; ACPI Devel 
>Maling List; Pallipadi, Venkatesh; Len Brown; Arjan van de Ven
>Subject: What's the right value for idle= (was: Re: [linux-pm] 
>regression on P-II SMP)
>
>On Sunday 21 February 2010, Guennadi Liakhovetski wrote:
>> Hi
>> 
>> my 2xP-II@400MHz locks up with 2.6.32(.X) unless I specify 
>"idle=*" on the 
>> kernel command-line, where "*" is one of "poll," "mwait," 
>"halt," and only 
>> "nomwait" indeed locks it up. Last kernel known to work was 
>2.6.25. So, it 
>> doesn't bother me all that much - I have a way to boot it, but maybe 
>> someone would be interested to fix this (this system already 
>has a few 
>> quirks on the kernel command line, so, one more doesn't 
>really hurt;)). 
>> What interests me more - which of those shall I be using? From 
>> Documentation/kernel-parameters.txt it looks like "mwait" 
>should be best 
>> for me? Or should I be using "halt?" "Poll" does indeed fry 
>CPUs - raises 
>> sys temperatures to 50 / 60 degrees C. Power-saving is not 
>that much of a 
>> concern for me - I only run that system occasionally, but it 
>shouldn't 
>> produce more heat than it must;) And since this system does 
>have a broken 
>> ACPI (Compaq AP400), I wouldn't try to be too smart with it.
>
>I guess "mwait" is the right one, but let's try to ask experts.
>

This CPU doesn't support mwait. So, idle=halt is what you should be using. That said, halt based idle is what should be used on this system by default, unless it supports ACPI based C-states. Can you send in the dmesg, with 2.6.25 without any boot parameter.

Thanks,
Venki