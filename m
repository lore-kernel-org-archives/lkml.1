Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbZJZSFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbZJZSFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbZJZSFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:05:00 -0400
Received: from relay3.sgi.com ([192.48.152.1]:39895 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754403AbZJZSE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:04:59 -0400
Message-ID: <4AE5E4D3.6060404@sgi.com>
Date: Mon, 26 Oct 2009 11:05:07 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Robin Getz <rgetz@analog.com>, Dave Young <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] SGI x86_64 UV: Add limit console output function
References: <20091023233743.439628000@alcatraz.americas.sgi.com>	 <20091023233746.128967000@alcatraz.americas.sgi.com>	 <87tyxmy6x6.fsf@basil.nowhere.org> <1256573457.26028.313.camel@gandalf.stny.rr.com>
In-Reply-To: <1256573457.26028.313.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Steven Rostedt wrote:
> On Mon, 2009-10-26 at 08:02 +0100, Andi Kleen wrote:
> 
>> Also more work could be done to make CPU boot up less verbose without
>> sacrifying debuggability if something goes wrong.
> 
> What about moving printks over to trace_printk or something. And that
> way we can have a "boot up" ring buffer that can later be retrieved if
> something goes wrong. It already dumps to the console on panic/oops.
> 
> The trace_printk will be hidden and is very fast.
> 
> -- Steve
> 

I haven't heard of "trace_printk" but how does this differ from the
existing kernel log buffer you get with 'dmesg'?

Thanks,
Mike

