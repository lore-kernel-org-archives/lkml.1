Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbYKHMbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbYKHMbz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 07:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbYKHMbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 07:31:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43120 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbYKHMbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 07:31:45 -0500
Date: Sat, 8 Nov 2008 13:31:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chris Snook <csnook@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] change CONFIG_NUMA description
Message-ID: <20081108123135.GI8354@elte.hu>
References: <20081105022553.7CB2.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081106085301.GB4890@elte.hu> <4914BD77.2080005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4914BD77.2080005@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Snook <csnook@redhat.com> wrote:

>> +	  For 32-bit this is only needed on (rare) 32-bit-only platforms
>> +	  that support NUMA topologies, such as NUMAQ / Summit, or if you
>> +	  boot a 32-bit kernel on a 64-bit NUMA platform.
>> +
>> +	  Otherwise, you should say N.
>>   comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
>>  	depends on X86_32 && X86_SUMMIT && (!HIGHMEM64G || !ACPI)
>
> Core i7, not Core 7i.

fixed that, thanks!

	Ingo
