Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbZKPVf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbZKPVf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbZKPVf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:35:26 -0500
Received: from relay3.sgi.com ([192.48.152.1]:39694 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753924AbZKPVfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:35:25 -0500
Message-ID: <4B01C59A.9050507@sgi.com>
Date: Mon, 16 Nov 2009 13:35:22 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] x86: Limit the number of per cpu MCE bootup messages
References: <20091116210718.412792000@alcatraz.americas.sgi.com> <20091116210727.456553000@alcatraz.americas.sgi.com> <20091116212251.GB2221@elte.hu>
In-Reply-To: <20091116212251.GB2221@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> @@ -83,6 +86,7 @@
>>  	unsigned long flags;
>>  	int hdr = 0;
>>  	int i;
>> +	char buf[120];
> 
> that constant is not particularly nice, is it?
> 
> 	Ingo

I'm up for suggestions.  I just noticed that during testing, the
MCE Banks messages overflowed 80 chars but I didn't actually
check to see what the longest might be.

Should I trim it to 80?  Or use a different constant?

Thanks,
Mike
