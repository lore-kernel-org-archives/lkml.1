Return-Path: <linux-kernel-owner+w=401wt.eu-S1758563AbYLLPir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbYLLPir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 10:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbYLLPij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 10:38:39 -0500
Received: from relay2.sgi.com ([192.48.179.30]:59309 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757005AbYLLPii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 10:38:38 -0500
Message-ID: <4942857A.8050909@sgi.com>
Date: Fri, 12 Dec 2008 07:38:34 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 3/4] cpumask: use maxcpus=NUM to extend the cpu limit
 as well as restrict the limit
References: <20081211112806.499831000@polaris-admin.engr.sgi.com> <20081211112807.004085000@polaris-admin.engr.sgi.com> <200812122211.36590.rusty@rustcorp.com.au>
In-Reply-To: <200812122211.36590.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thursday 11 December 2008 21:58:09 Mike Travis wrote:
>> Impact: allow adding additional cpus.
>>
>> Use maxcpus=NUM kernel parameter to extend the number of possible cpus as well
>> as (currently) limit them.  Any cpus >= number of present cpus will disabled.
> ...
> 
> These two bits of logic are very similar: can we merge them?
> 
...

Since there's already precedence for "possible_cpus=XXX" might that be a better
alternative?  In which case maxcpus does not need to change at all.

Thanks,
Mike
